# CLAUDE.md Example: Express.js REST API

## E-Commerce REST API

### Tech Stack
- Node.js 18 + Express 4
- PostgreSQL 14
- Redis 7 (caching)
- Stripe (payments)
- SendGrid (emails)

### Core Principles
1. **Thin routes**: Routes orchestrate, services contain logic
2. **Repository pattern**: All DB access through repositories
3. **Error middleware**: Centralized error handling
4. **TDD**: Tests before implementation

### Route Pattern
```javascript
router.post('/products',
  authenticate(),           // JWT validation
  authorize('admin'),       // Role check
  validate(productSchema),  // Input validation
  async (req, res, next) => {
    try {
      const product = await productService.create(req.body);
      res.status(201).json({ success: true, data: product });
    } catch (error) {
      next(error);
    }
  }
);
```

### Service Pattern
```javascript
class ProductService {
  async create(productData) {
    // Validate business rules
    await this.validateSKU(productData.sku);
    
    // Transform data
    const product = this.prepareProduct(productData);
    
    // Save
    return await this.productRepository.create(product);
  }
}
```

### Database Conventions
- Tables: `snake_case` (user_orders)
- Columns: `snake_case` (created_at)
- Indexes: `idx_tablename_columnname`
- Foreign keys: `fk_table1_table2`

### Testing Pattern
```javascript
describe('ProductService', () => {
  beforeEach(() => {
    // Reset database
  });
  
  describe('create', () => {
    it('creates product with valid data', async () => {
      const data = { name: 'Widget', price: 1999, sku: 'W-001' };
      const product = await service.create(data);
      expect(product.price).toBe(1999);
    });
  });
});
```

