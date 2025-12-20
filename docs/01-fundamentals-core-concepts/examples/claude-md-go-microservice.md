# CLAUDE.md Example: Go Microservice

## Payment Microservice

### Tech Stack
- Go 1.21
- gRPC (inter-service communication)
- PostgreSQL
- Redis (caching)

### Project Structure
```
cmd/
  └── server/        # Main application
internal/
  ├── domain/        # Business logic
  ├── infrastructure/# DB, Redis, external APIs
  └── interfaces/    # gRPC, HTTP handlers
pkg/                 # Public libraries
```

### Naming Conventions
- Files: `snake_case.go`
- Packages: `lowercase` (no underscores)
- Interfaces: `Type + er` (Reader, Writer)
- Structs: `PascalCase`
- Functions: `PascalCase` (exported), `camelCase` (unexported)

### Error Handling
```go
func (s *PaymentService) ProcessPayment(ctx context.Context, req *PaymentRequest) (*Payment, error) {
    // Validate
    if err := validate(req); err != nil {
        return nil, fmt.Errorf("validation failed: %w", err)
    }
    
    // Process
    payment, err := s.stripe.Charge(ctx, req)
    if err != nil {
        return nil, fmt.Errorf("stripe charge failed: %w", err)
    }
    
    return payment, nil
}
```

Always wrap errors with context using `fmt.Errorf` and `%w`.

### Testing Pattern
```go
func TestProcessPayment(t *testing.T) {
    // Arrange
    service := NewPaymentService(mockStripe)
    req := &PaymentRequest{Amount: 5000}
    
    // Act
    payment, err := service.ProcessPayment(context.Background(), req)
    
    // Assert
    assert.NoError(t, err)
    assert.Equal(t, 5000, payment.Amount)
}
```

### Concurrency
- Use channels for communication
- Use sync.WaitGroup for goroutine coordination
- Always have timeout context
- Avoid shared mutable state

```go
func processAsync(items []Item) []Result {
    results := make(chan Result, len(items))
    var wg sync.WaitGroup
    
    for _, item := range items {
        wg.Add(1)
        go func(i Item) {
            defer wg.Done()
            results <- process(i)
        }(item)
    }
    
    go func() {
        wg.Wait()
        close(results)
    }()
    
    return collectResults(results)
}
```

