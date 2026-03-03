"""
endpoint-template.py

Reference implementation of a complete FastAPI REST endpoint.
Demonstrates the exact pattern taught by the api-endpoint-generator skill:

  - Pydantic v2 models for request and response validation
  - Field constraints declared in the schema, not the handler
  - HTTPException for expected business errors (4xx)
  - Fully typed function signatures — no plain `dict` returns
  - RFC 7807-style error details via HTTPException.detail
  - Docstrings on every model and endpoint
  - Pytest stub at the bottom using httpx's async client

Usage:
  pip install fastapi pydantic[email] httpx uvicorn
  uvicorn endpoint_template:router --reload

  Or mount the router in your main FastAPI app:
    from endpoint_template import router as product_router
    app.include_router(product_router)
"""

from __future__ import annotations

from datetime import datetime, timezone
from enum import StrEnum
from typing import Annotated
from uuid import UUID, uuid4

from fastapi import APIRouter, HTTPException, Path, Query, status
from pydantic import BaseModel, EmailStr, Field, field_validator, model_validator

# =============================================================================
# 1. ENUMERATIONS — define valid discrete values as enums, not raw strings
# =============================================================================

class ProductCategory(StrEnum):
    """Valid categories for a product listing."""
    ELECTRONICS = "electronics"
    CLOTHING = "clothing"
    BOOKS = "books"
    FOOD = "food"
    OTHER = "other"

# =============================================================================
# 2. REQUEST SCHEMAS — Pydantic v2 models with full field constraints
# =============================================================================

class CreateProductRequest(BaseModel):
    """
    Request body for creating a new product listing.

    All validation constraints are declared at the field level.
    FastAPI returns HTTP 422 automatically if validation fails.
    """

    name: Annotated[str, Field(min_length=2, max_length=200, examples=["Wireless Headphones"])]
    description: Annotated[str | None, Field(max_length=2000, default=None)]
    price_in_cents: Annotated[int, Field(ge=1, le=99_999_999, description="Price in cents (e.g. 999 = $9.99)")]
    category: ProductCategory
    stock_quantity: Annotated[int, Field(ge=0, default=0)]
    tags: Annotated[list[str], Field(max_length=10, default_factory=list)]

    @field_validator("name")
    @classmethod
    def name_must_not_be_blank(cls, value: str) -> str:
        """Reject names that are only whitespace after stripping."""
        stripped = value.strip()
        if not stripped:
            raise ValueError("Name must not be blank or whitespace only")
        return stripped

    @field_validator("tags")
    @classmethod
    def tags_must_be_non_empty_strings(cls, value: list[str]) -> list[str]:
        """Each tag must be a non-empty string after stripping."""
        validated = [t.strip() for t in value]
        if any(not t for t in validated):
            raise ValueError("Each tag must be a non-empty string")
        return validated


class UpdateProductRequest(BaseModel):
    """
    Request body for partially updating an existing product.

    All fields are optional — only the provided fields are changed.
    This implements PATCH semantics correctly.
    """

    name: Annotated[str | None, Field(min_length=2, max_length=200, default=None)]
    description: str | None = None
    price_in_cents: Annotated[int | None, Field(ge=1, le=99_999_999, default=None)]
    category: ProductCategory | None = None
    stock_quantity: Annotated[int | None, Field(ge=0, default=None)]
    tags: list[str] | None = None

    @model_validator(mode="after")
    def at_least_one_field_required(self) -> "UpdateProductRequest":
        """Ensure the PATCH body is not empty."""
        if all(v is None for v in self.model_dump().values()):
            raise ValueError("At least one field must be provided for update")
        return self


# =============================================================================
# 3. RESPONSE SCHEMAS — always return a typed model, never a raw dict
# =============================================================================

class ProductResponse(BaseModel):
    """The product representation returned by the API."""

    id: UUID
    name: str
    description: str | None
    price_in_cents: int
    category: ProductCategory
    stock_quantity: int
    tags: list[str]
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}  # Allows construction from ORM objects


class ProductListResponse(BaseModel):
    """Paginated list of products."""

    items: list[ProductResponse]
    total: int
    page: int
    page_size: int


# =============================================================================
# 4. ROUTE HANDLERS — each handler is a single async function
# =============================================================================

router = APIRouter(prefix="/products", tags=["products"])


@router.post(
    "/",
    response_model=ProductResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new product listing",
    responses={
        409: {"description": "A product with this name already exists in this category"},
        422: {"description": "Request body validation failed"},
    },
)
async def create_product(payload: CreateProductRequest) -> ProductResponse:
    """
    Create a new product listing.

    - **name**: 2–200 characters, whitespace stripped
    - **price_in_cents**: Must be a positive integer (e.g., 999 = $9.99)
    - **category**: Must be one of the predefined categories
    - **tags**: Up to 10 non-empty tags
    """
    try:
        # Replace with your actual service/repository call
        created = await product_service.create(
            name=payload.name,
            description=payload.description,
            price_in_cents=payload.price_in_cents,
            category=payload.category,
            stock_quantity=payload.stock_quantity,
            tags=payload.tags,
        )
    except DuplicateProductError as exc:
        # Expected business error — raise as HTTPException, not a generic Exception
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={
                "type": "https://errors.myapp.com/duplicate-product",
                "title": "Duplicate Product",
                "status": 409,
                "detail": f"A product named '{payload.name}' already exists in category '{payload.category}'.",
            },
        ) from exc

    # Return a Pydantic model — FastAPI serializes it automatically
    # from_orm=True (model_config above) lets this work with SQLAlchemy models too
    return ProductResponse.model_validate(created)


@router.get(
    "/{product_id}",
    response_model=ProductResponse,
    summary="Retrieve a product by ID",
    responses={
        404: {"description": "Product not found"},
    },
)
async def get_product(
    product_id: Annotated[UUID, Path(description="The product's unique identifier")],
) -> ProductResponse:
    """
    Retrieve a single product by its UUID.

    FastAPI automatically validates that `product_id` is a valid UUID format
    and returns 422 if it is not — no manual validation needed here.
    """
    product = await product_service.find_by_id(product_id)

    if product is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "type": "https://errors.myapp.com/not-found",
                "title": "Product Not Found",
                "status": 404,
                "detail": f"No product was found with id '{product_id}'.",
            },
        )

    return ProductResponse.model_validate(product)


@router.get(
    "/",
    response_model=ProductListResponse,
    summary="List products with optional filtering",
)
async def list_products(
    category: Annotated[ProductCategory | None, Query(description="Filter by category")] = None,
    page: Annotated[int, Query(ge=1, description="Page number (1-based)")] = 1,
    page_size: Annotated[int, Query(ge=1, le=100, description="Results per page")] = 20,
) -> ProductListResponse:
    """
    Return a paginated list of products, optionally filtered by category.

    Query parameters:
    - **category**: Optional. Filter to products in this category.
    - **page**: Page number, starting at 1.
    - **page_size**: Number of results per page (max 100).
    """
    items, total = await product_service.list_all(
        category=category,
        offset=(page - 1) * page_size,
        limit=page_size,
    )

    return ProductListResponse(
        items=[ProductResponse.model_validate(item) for item in items],
        total=total,
        page=page,
        page_size=page_size,
    )


@router.patch(
    "/{product_id}",
    response_model=ProductResponse,
    summary="Partially update an existing product",
    responses={
        404: {"description": "Product not found"},
    },
)
async def update_product(
    product_id: Annotated[UUID, Path(description="The product's unique identifier")],
    payload: UpdateProductRequest,
) -> ProductResponse:
    """
    Partially update a product. Only fields included in the request body are changed.

    Send an empty body `{}` to receive a 422 — at least one field is required.
    """
    updated = await product_service.update(
        product_id=product_id,
        # Use model_dump(exclude_none=True) to apply only the provided fields
        updates=payload.model_dump(exclude_none=True),
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "type": "https://errors.myapp.com/not-found",
                "title": "Product Not Found",
                "status": 404,
                "detail": f"No product was found with id '{product_id}'.",
            },
        )

    return ProductResponse.model_validate(updated)


# =============================================================================
# 5. PYTEST STUB — paste into test_products.py and complete the assertions
# =============================================================================

"""
# test_products.py

import pytest
from httpx import AsyncClient, ASGITransport
from fastapi import FastAPI
from unittest.mock import AsyncMock, patch
from uuid import uuid4
from datetime import datetime, timezone

from endpoint_template import router

app = FastAPI()
app.include_router(router)

SAMPLE_PRODUCT_ID = uuid4()
SAMPLE_PRODUCT = {
    "id": str(SAMPLE_PRODUCT_ID),
    "name": "Wireless Headphones",
    "description": None,
    "price_in_cents": 9999,
    "category": "electronics",
    "stock_quantity": 100,
    "tags": [],
    "created_at": datetime.now(timezone.utc).isoformat(),
    "updated_at": datetime.now(timezone.utc).isoformat(),
}

@pytest.fixture
async def client():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        yield ac

@pytest.mark.anyio
async def test_create_product_returns_201(client):
    with patch("endpoint_template.product_service.create", new_callable=AsyncMock) as mock_create:
        mock_create.return_value = SAMPLE_PRODUCT
        response = await client.post("/products/", json={
            "name": "Wireless Headphones",
            "price_in_cents": 9999,
            "category": "electronics",
        })
    assert response.status_code == 201
    assert response.json()["name"] == "Wireless Headphones"

@pytest.mark.anyio
async def test_create_product_returns_422_for_missing_name(client):
    response = await client.post("/products/", json={
        "price_in_cents": 9999,
        "category": "electronics",
    })
    assert response.status_code == 422

@pytest.mark.anyio
async def test_create_product_returns_422_for_negative_price(client):
    response = await client.post("/products/", json={
        "name": "Widget",
        "price_in_cents": -1,
        "category": "other",
    })
    assert response.status_code == 422

@pytest.mark.anyio
async def test_get_product_returns_404_for_unknown_id(client):
    with patch("endpoint_template.product_service.find_by_id", new_callable=AsyncMock) as mock_find:
        mock_find.return_value = None
        response = await client.get(f"/products/{uuid4()}")
    assert response.status_code == 404
"""
