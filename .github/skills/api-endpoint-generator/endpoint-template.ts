/**
 * endpoint-template.ts
 *
 * Reference implementation of a complete Express.js REST endpoint.
 * Demonstrates the exact pattern taught by the api-endpoint-generator skill:
 *
 *   - Zod schema for input validation and TypeScript type inference
 *   - Typed Request / Response generics (no `any`)
 *   - RFC 7807 Problem Details error format
 *   - Async/await error handling with next(error) delegation
 *   - Immutable response construction
 *   - JSDoc on every public function and type
 *
 * To use as a starting point:
 *   1. Replace "Product" with your resource name (find+replace)
 *   2. Update the Zod schema fields to match your resource
 *   3. Replace `productService.*` calls with your actual service/repository
 *   4. Adjust the route path in the router registration at the bottom
 */

import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

// =============================================================================
// 1. INPUT SCHEMA — single source of truth for validation AND TypeScript types
// =============================================================================

/**
 * Zod schema for the Create Product request body.
 * Every constraint is expressed here — the handler stays clean.
 */
const CreateProductSchema = z.object({
  name: z
    .string()
    .min(2, 'Name must be at least 2 characters')
    .max(200, 'Name must not exceed 200 characters')
    .trim(),
  description: z
    .string()
    .max(2000, 'Description must not exceed 2000 characters')
    .optional(),
  priceInCents: z
    .number()
    .int('Price must be an integer (cents)')
    .min(1, 'Price must be at least 1 cent')
    .max(999_999_99, 'Price must not exceed $9,999,999.99'),
  category: z.enum(['electronics', 'clothing', 'books', 'food', 'other'], {
    errorMap: () => ({ message: 'Category must be one of: electronics, clothing, books, food, other' }),
  }),
  stockQuantity: z
    .number()
    .int('Stock must be a whole number')
    .min(0, 'Stock cannot be negative')
    .default(0),
  tags: z.array(z.string().max(50)).max(10, 'Cannot have more than 10 tags').default([]),
});

/**
 * Zod schema for the Update Product request body.
 * `.partial()` makes all fields optional — standard for PATCH semantics.
 */
const UpdateProductSchema = CreateProductSchema.partial();

// =============================================================================
// 2. TYPESCRIPT TYPES — inferred from schemas, never hand-written separately
// =============================================================================

/** Input for creating a new product. Inferred from {@link CreateProductSchema}. */
type CreateProductInput = z.infer<typeof CreateProductSchema>;

/** Input for partially updating a product. Inferred from {@link UpdateProductSchema}. */
type UpdateProductInput = z.infer<typeof UpdateProductSchema>;

/** The response shape returned by product endpoints. */
interface ProductResponse {
  readonly id: string;
  readonly name: string;
  readonly description: string | null;
  readonly priceInCents: number;
  readonly category: CreateProductInput['category'];
  readonly stockQuantity: number;
  readonly tags: readonly string[];
  readonly createdAt: string; // ISO 8601
  readonly updatedAt: string; // ISO 8601
}

// =============================================================================
// 3. ROUTE HANDLERS
// =============================================================================

/**
 * POST /products
 *
 * Creates a new product listing.
 *
 * @param req.body - {@link CreateProductInput} — validated by Zod
 * @returns 201 with {@link ProductResponse} of the newly created product
 * @throws 400 if the request body fails schema validation
 * @throws 409 if a product with the same name already exists in this category
 */
async function createProduct(
  req: Request,
  res: Response<ProductResponse>,
  next: NextFunction,
): Promise<void> {
  const parseResult = CreateProductSchema.safeParse(req.body);

  if (!parseResult.success) {
    // Return RFC 7807 Problem Details — never expose raw Zod error objects
    res.status(400).json({
      type: 'https://errors.myapp.com/validation-error',
      title: 'Validation Error',
      status: 400,
      detail: 'The request body contains one or more invalid fields.',
      errors: parseResult.error.flatten().fieldErrors,
    } as unknown as ProductResponse);
    return;
  }

  const input: CreateProductInput = parseResult.data;

  try {
    const product = await productService.create(input);

    // Construct response immutably — never mutate the returned entity
    const response: ProductResponse = {
      id: product.id,
      name: product.name,
      description: product.description ?? null,
      priceInCents: product.priceInCents,
      category: product.category,
      stockQuantity: product.stockQuantity,
      tags: [...product.tags], // defensive copy — return value is read-only
      createdAt: product.createdAt.toISOString(),
      updatedAt: product.updatedAt.toISOString(),
    };

    res.status(201).json(response);
  } catch (error) {
    // Delegate to centralized error-handling middleware
    // Do NOT swallow the error or return 500 manually here
    next(error);
  }
}

/**
 * GET /products/:id
 *
 * Retrieves a single product by its unique identifier.
 *
 * @param req.params.id - The product's UUID
 * @returns 200 with {@link ProductResponse}
 * @throws 400 if `id` is not a valid UUID format
 * @throws 404 if no product with the given id exists
 */
async function getProductById(
  req: Request<{ id: string }>,
  res: Response<ProductResponse>,
  next: NextFunction,
): Promise<void> {
  const idSchema = z.string().uuid('Product id must be a valid UUID');
  const parseResult = idSchema.safeParse(req.params.id);

  if (!parseResult.success) {
    res.status(400).json({
      type: 'https://errors.myapp.com/invalid-id',
      title: 'Invalid ID Format',
      status: 400,
      detail: 'The provided product id is not a valid UUID.',
    } as unknown as ProductResponse);
    return;
  }

  try {
    const product = await productService.findById(parseResult.data);

    if (!product) {
      res.status(404).json({
        type: 'https://errors.myapp.com/not-found',
        title: 'Product Not Found',
        status: 404,
        detail: `No product was found with id '${req.params.id}'.`,
      } as unknown as ProductResponse);
      return;
    }

    const response: ProductResponse = {
      id: product.id,
      name: product.name,
      description: product.description ?? null,
      priceInCents: product.priceInCents,
      category: product.category,
      stockQuantity: product.stockQuantity,
      tags: [...product.tags],
      createdAt: product.createdAt.toISOString(),
      updatedAt: product.updatedAt.toISOString(),
    };

    res.status(200).json(response);
  } catch (error) {
    next(error);
  }
}

/**
 * PATCH /products/:id
 *
 * Partially updates an existing product.
 * Only the fields included in the request body are changed.
 *
 * @param req.params.id - The product's UUID
 * @param req.body - {@link UpdateProductInput} — all fields optional
 * @returns 200 with the updated {@link ProductResponse}
 * @throws 400 if `id` is invalid or body fails validation
 * @throws 404 if no product with the given id exists
 */
async function updateProduct(
  req: Request<{ id: string }>,
  res: Response<ProductResponse>,
  next: NextFunction,
): Promise<void> {
  const idSchema = z.string().uuid();
  const idResult = idSchema.safeParse(req.params.id);

  if (!idResult.success) {
    res.status(400).json({
      type: 'https://errors.myapp.com/invalid-id',
      title: 'Invalid ID Format',
      status: 400,
      detail: 'The provided product id is not a valid UUID.',
    } as unknown as ProductResponse);
    return;
  }

  const bodyResult = UpdateProductSchema.safeParse(req.body);

  if (!bodyResult.success) {
    res.status(400).json({
      type: 'https://errors.myapp.com/validation-error',
      title: 'Validation Error',
      status: 400,
      detail: 'One or more fields in the request body are invalid.',
      errors: bodyResult.error.flatten().fieldErrors,
    } as unknown as ProductResponse);
    return;
  }

  const input: UpdateProductInput = bodyResult.data;

  try {
    const updated = await productService.update(idResult.data, input);

    if (!updated) {
      res.status(404).json({
        type: 'https://errors.myapp.com/not-found',
        title: 'Product Not Found',
        status: 404,
        detail: `No product was found with id '${req.params.id}'.`,
      } as unknown as ProductResponse);
      return;
    }

    const response: ProductResponse = {
      id: updated.id,
      name: updated.name,
      description: updated.description ?? null,
      priceInCents: updated.priceInCents,
      category: updated.category,
      stockQuantity: updated.stockQuantity,
      tags: [...updated.tags],
      createdAt: updated.createdAt.toISOString(),
      updatedAt: updated.updatedAt.toISOString(),
    };

    res.status(200).json(response);
  } catch (error) {
    next(error);
  }
}

// =============================================================================
// 4. ROUTER REGISTRATION — group all product routes under /products
// =============================================================================

export const productRouter = Router();

productRouter.post('/', createProduct);
productRouter.get('/:id', getProductById);
productRouter.patch('/:id', updateProduct);

// =============================================================================
// 5. UNIT TEST STUB — paste into products.test.ts and fill in the assertions
// =============================================================================

/*
import { describe, it, expect, vi, beforeEach } from 'vitest';
import request from 'supertest';
import express from 'express';
import { productRouter } from './endpoint-template';

// Mock the service layer so tests are isolated from the database
vi.mock('./product-service', () => ({
  productService: {
    create: vi.fn(),
    findById: vi.fn(),
    update: vi.fn(),
  },
}));

const app = express();
app.use(express.json());
app.use('/products', productRouter);

describe('POST /products', () => {
  const validBody = {
    name: 'Wireless Headphones',
    priceInCents: 9999,
    category: 'electronics',
  };

  it('returns 201 with the created product for valid input', async () => {
    productService.create.mockResolvedValueOnce({ id: 'abc-123', ...validBody, ... });
    const res = await request(app).post('/products').send(validBody);
    expect(res.status).toBe(201);
    expect(res.body.id).toBeDefined();
  });

  it('returns 400 when required field "name" is missing', async () => {
    const { name, ...bodyWithoutName } = validBody;
    const res = await request(app).post('/products').send(bodyWithoutName);
    expect(res.status).toBe(400);
    expect(res.body.errors.name).toBeDefined();
  });

  it('returns 400 when priceInCents is not an integer', async () => {
    const res = await request(app).post('/products').send({ ...validBody, priceInCents: 9.99 });
    expect(res.status).toBe(400);
  });
});
*/
