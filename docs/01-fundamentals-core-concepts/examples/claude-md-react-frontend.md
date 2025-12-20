# CLAUDE.md Example: React Frontend

## Dashboard Frontend

### Tech Stack
- React 18
- TypeScript
- Tailwind CSS
- React Query (server state)
- Zustand (client state)

### Component Structure
```
src/
  ├── components/     # Shared components
  │   ├── Button/
  │   │   ├── Button.tsx
  │   │   ├── Button.module.css
  │   │   └── Button.test.tsx
  │   └── ...
  ├── features/       # Feature-specific components
  │   ├── auth/
  │   ├── products/
  │   └── ...
  ├── hooks/          # Custom hooks
  ├── services/       # API calls
  └── stores/         # Zustand stores
```

### Component Pattern
```typescript
interface ButtonProps {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  onClick?: () => void;
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  onClick,
  children
}) => {
  return (
    <button
      className={`btn btn-${variant} btn-${size}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```

### State Management
- **Local state**: useState (component-specific)
- **Form state**: React Hook Form
- **Server state**: React Query (API data)
- **Global state**: Zustand (theme, user, etc.)

**Example**:
```typescript
// Zustand store
const useAuthStore = create<AuthState>((set) => ({
  user: null,
  login: (user) => set({ user }),
  logout: () => set({ user: null }),
}));

// React Query
const { data, isLoading } = useQuery({
  queryKey: ['products'],
  queryFn: fetchProducts
});
```

### Styling Conventions
- Tailwind for utilities
- CSS Modules for custom components
- NO inline styles
- Design tokens in `tailwind.config.js`

### Testing
```typescript
describe('Button', () => {
  it('renders with primary variant', () => {
    render(<Button variant="primary">Click</Button>);
    expect(screen.getByText('Click')).toHaveClass('btn-primary');
  });
  
  it('calls onClick when clicked', () => {
    const onClick = jest.fn();
    render(<Button onClick={onClick}>Click</Button>);
    fireEvent.click(screen.getByText('Click'));
    expect(onClick).toHaveBeenCalled();
  });
});
```

