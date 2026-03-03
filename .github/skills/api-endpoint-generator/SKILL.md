---
name: api-endpoint-generator
description: Scaffold complete REST API endpoints with input validation, error handling, typed request/response, JSDoc or docstrings, and a unit test stub. Use when asked to create a new API route, endpoint, controller, handler, or REST resource in Express.js (TypeScript) or FastAPI (Python). Produces production-ready code following immutable patterns, Zod/Pydantic validation, and RFC 7807 error responses.
license: MIT
compatibility: TypeScript 5+ with Express 5, or Python 3.10+ with FastAPI 0.100+. Requires zod (TS) or pydantic v2 (Python).
metadata:
  author: copilot-dev-course
  version: "1.0"
allowed-tools: read_file write_file
---

# API Endpoint Generator Skill

You are an expert API designer. When this skill activates, you generate **complete, production-ready REST API endpoints** for either TypeScript/Express or Python/FastAPI. Follow every step below exactly.

## Step 1: Gather Requirements

Before generating any code, determine:

1. **Framework**: TypeScript + Express, or Python + FastAPI?
2. **Resource**: What entity is being managed? (e.g., `User`, `Order`, `Product`)
3. **HTTP method and path**: `GET /users/:id`, `POST /products`, etc.
4. **Input shape**: What fields does the request body, path params, or query params contain?
5. **Output shape**: What does a success response look like?
6. **Business rules**: Any constraints on the input? (e.g., email must be unique, age >= 18)

If any of these are missing from the user's prompt, ask for them before generating.

## Step 2: Apply the Standard Output Structure

Every generated endpoint must include **all five layers**:

| Layer | Purpose |
|---|---|
| **Schema / Validator** | Zod (TS) or Pydantic (Python) defines input shape and validates at the boundary |
| **Route Handler** | The async function that orchestrates validation, logic, and response |
| **Typed Request/Response** | TypeScript generics or Python type hints — no `any`, no `dict` without hints |
| **Error Handling** | RFC 7807 Problem Details format for all 4xx/5xx responses |
| **Unit Test Stub** | Vitest (TS) or pytest (Python) — all happy path + key error paths |

## Step 3: TypeScript / Express Pattern

Follow this exact template for TypeScript endpoints:

```typescript
import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

// --- 1. Input schema (validates and infers the TS type simultaneously) ---
const CreateUserSchema = z.object({
  email: z.string().email({ message: 'Must be a valid email address' }),
  name: z.string().min(2).max(100),
  age: z.number().int().min(0).max(150),
});

// Infer the TypeScript type from the schema — single source of truth
type CreateUserInput = z.infer<typeof CreateUserSchema>;

// --- 2. Response type ---
interface UserResponse {
  id: string;
  email: string;
  name: string;
  createdAt: string;
}

// --- 3. Route handler ---
/**
 * POST /users
 *
 * Creates a new user account.
 *
 * @param req.body - {@link CreateUserInput}
 * @returns 201 with the created {@link UserResponse}
 * @throws 400 if the request body fails validation
 * @throws 409 if the email address is already registered
 */
async function createUser(
  req: Request,
  res: Response<UserResponse>,
  next: NextFunction,
): Promise<void> {
  // Validate input — parse() throws ZodError on failure
  const parseResult = CreateUserSchema.safeParse(req.body);

  if (!parseResult.success) {
    // RFC 7807 Problem Details — consistent error envelope
    res.status(400).json({
      type: 'https://errors.myapp.com/validation-error',
      title: 'Validation Error',
      status: 400,
      detail: 'One or more fields failed validation.',
      errors: parseResult.error.flatten().fieldErrors,
    } as any);
    return;
  }

  // parseResult.data is now fully typed as CreateUserInput
  const input: CreateUserInput = parseResult.data;

  try {
    // Replace with your actual service/repository call
    const user = await userService.create(input);

    // Return immutable response — never mutate the entity object directly
    res.status(201).json({
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt.toISOString(),
    });
  } catch (error) {
    // Delegate unexpected errors to Express error middleware
    next(error);
  }
}

// --- 4. Router registration ---
export const userRouter = Router();
userRouter.post('/', createUser);
```

### Key rules for TypeScript endpoints

- **Never use `any`** for request/response types — use Zod inference
- **Always use `safeParse()`** not `parse()` — lets you control the 400 response format
- **Immutable response objects** — spread or construct new objects, never mutate DB entities
- **Pass unknown errors to `next(error)`** — let centralized error middleware handle 500s
- **Use `async/await`** — no callbacks, no Promise chains

## Step 4: Python / FastAPI Pattern

Follow this exact template for Python endpoints:

```python
from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, EmailStr, Field, field_validator
from uuid import UUID, uuid4
from datetime import datetime, timezone

router = APIRouter(prefix="/users", tags=["users"])


# --- 1. Request schema (Pydantic v2) ---
class CreateUserRequest(BaseModel):
    """Request body for creating a new user."""
    email: EmailStr
    name: str = Field(min_length=2, max_length=100)
    age: int = Field(ge=0, le=150)

    @field_validator("name")
    @classmethod
    def name_must_not_be_blank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("Name must not be blank or whitespace only")
        return value.strip()


# --- 2. Response schema ---
class UserResponse(BaseModel):
    """Response body returned after creating a user."""
    id: UUID
    email: str
    name: str
    created_at: datetime


# --- 3. Route handler ---
@router.post(
    "/",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new user account",
    responses={
        409: {"description": "Email address already registered"},
    },
)
async def create_user(payload: CreateUserRequest) -> UserResponse:
    """
    Create a new user account.

    - **email**: Must be a valid email address and unique in the system
    - **name**: Between 2 and 100 characters
    - **age**: Between 0 and 150
    """
    # FastAPI validates payload automatically via Pydantic — 422 on failure
    try:
        # Replace with your actual service/repository call
        created = await user_service.create(
            email=payload.email,
            name=payload.name,
            age=payload.age,
        )
    except DuplicateEmailError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Email '{payload.email}' is already registered.",
        ) from exc

    # Return an immutable response model — Pydantic serializes it
    return UserResponse(
        id=created.id,
        email=created.email,
        name=created.name,
        created_at=created.created_at,
    )
```

### Key rules for Python endpoints

- **Use `EmailStr`** from pydantic-email-validator for email fields
- **`Field(ge=..., le=...)`** for numeric constraints — not custom logic in the handler
- **`@field_validator`** for cross-field or complex validation
- **`response_model=`** on the decorator — FastAPI filters and validates output automatically
- **Raise `HTTPException`** for expected business errors, not generic `Exception`
- **Never return raw dict** — always return a Pydantic model instance

## Step 5: Error Response Format (RFC 7807)

All error responses must use this envelope — consistent across both frameworks:

```json
{
  "type": "https://errors.myapp.com/validation-error",
  "title": "Validation Error",
  "status": 400,
  "detail": "One or more fields failed validation.",
  "errors": {
    "email": ["Must be a valid email address"],
    "age": ["Must be between 0 and 150"]
  }
}
```

FastAPI returns 422 Unprocessable Entity with a similar format automatically from Pydantic.

## Step 6: Unit Test Stub

Always generate a test file alongside the endpoint. Name it:

- TypeScript: `users.test.ts` using Vitest
- Python: `test_users.py` using pytest + httpx

The stub must include test cases for:

1. **Happy path** — valid input returns correct status code and response shape
2. **Validation error** — missing required field returns 400/422
3. **Validation error** — invalid field type returns 400/422
4. **Business error** — e.g., duplicate email returns 409

## Step 7: Output Checklist

Before delivering any generated code:

- [ ] Input schema covers all required fields with appropriate constraints
- [ ] TypeScript: `safeParse()` used; type inferred via `z.infer<>`
- [ ] Python: `response_model=` set on route decorator
- [ ] No `any` types (TypeScript) or untyped `dict` (Python)
- [ ] Error response uses RFC 7807 format
- [ ] Unknown errors delegated to middleware (`next(error)`) or re-raised as `HTTPException`
- [ ] JSDoc / docstring covers: what it does, params, returns, throws
- [ ] Test stub covers happy path + at least 2 error paths

## Reference Files

- `endpoint-template.ts` — Complete TypeScript/Express endpoint with Zod validation
- `endpoint-template.py` — Complete Python/FastAPI endpoint with Pydantic v2
