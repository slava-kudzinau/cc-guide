# CLAUDE.md Example: Python Data Pipeline

## Data Processing Pipeline

### Tech Stack
- Python 3.11
- Pandas (data manipulation)
- DuckDB (local analytics)
- Apache Airflow (orchestration)
- Pytest (testing)

### Project Structure
```
src/
  ├── extractors/    # Data sources
  ├── transformers/  # Data transformation
  ├── loaders/       # Data destinations
  ├── utils/         # Helpers
  └── dags/          # Airflow DAGs
```

### Code Conventions
- Functions: `snake_case`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Type hints: Always (enforced by mypy)

### ETL Pattern
```python
def extract() -> pd.DataFrame:
    """Extract data from source."""
    return pd.read_csv('data.csv')

def transform(df: pd.DataFrame) -> pd.DataFrame:
    """Transform data."""
    return df.dropna().query('age > 18')

def load(df: pd.DataFrame) -> None:
    """Load data to destination."""
    df.to_parquet('output.parquet')

# Pipeline
df = extract()
df = transform(df)
load(df)
```

### Testing Pattern
```python
def test_transform_removes_nulls():
    # Arrange
    df = pd.DataFrame({'age': [25, None, 30]})
    
    # Act
    result = transform(df)
    
    # Assert
    assert len(result) == 2
    assert result['age'].isna().sum() == 0
```

### Type Hints (Mandatory)
```python
from typing import List, Dict, Optional

def process_users(
    users: List[Dict[str, str]],
    filter_active: bool = True
) -> List[str]:
    """Process user data.
    
    Args:
        users: List of user dictionaries
        filter_active: Whether to filter active users
        
    Returns:
        List of user IDs
    """
    return [u['id'] for u in users if not filter_active or u['active']]
```

