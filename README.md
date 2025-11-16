# My Embedded Database

A multi-language embedded database built in Rust with bindings for Python, Go, and JavaScript/Node.js.

## Project Structure

```
my_embedded_db/
├── .gitignore
├── Cargo.toml          # Main workspace file
├── README.md
│
├── crates/
│   ├── db_core/        # Core database logic (pure Rust)
│   │   ├── Cargo.toml
│   │   └── src/lib.rs
│   │
│   └── db_ffi/         # C-API "translation" layer
│       ├── Cargo.toml
│       ├── build.rs    # Build script for generating C headers
│       └── src/lib.rs
│
└── bindings/
    ├── python/         # Python wrapper
    │   ├── setup.py
    │   └── my_embedded_db_py/
    │       ├── __init__.py
    │       └── database.py
    │
    ├── go/             # Go wrapper
    │   ├── go.mod
    │   └── my_embedded_db_go.go
    │
    └── js/             # JavaScript (Node.js) wrapper
        ├── package.json
        └── index.js
```

## Features

- **Fast**: Built in Rust for maximum performance
- **Safe**: Memory-safe implementation with proper error handling
- **Multi-language**: Bindings for Python, Go, and JavaScript/Node.js
- **Simple API**: Clean, consistent interface across all languages
- **Embedded**: No external dependencies, runs in-process

## Building

### Prerequisites

- [Rust](https://rustup.rs/) (latest stable version)
- [Python](https://python.org/) 3.7+ (for Python bindings)
- [Go](https://golang.org/) 1.19+ (for Go bindings)
- [Node.js](https://nodejs.org/) 14+ (for JavaScript bindings)

### Build the Core Library

```bash
# Build the FFI library in release mode
cargo build --release -p db_ffi

# This will generate:
# - target/release/libdb_ffi.so (Linux)
# - target/release/libdb_ffi.dylib (macOS)
# - target/release/db_ffi.dll (Windows)
```

## Language Bindings

### Python

```bash
cd bindings/python
pip install -e .
```

Usage:
```python
from my_embedded_db_py import Database

# Create an in-memory database
db = Database()

# Store data
db.put("hello", b"world")

# Retrieve data
value = db.get("hello")
print(value)  # b'world'

# Check existence
if db.exists("hello"):
    print("Key exists!")

# Clean up
db.close()
```

### Go

```bash
cd bindings/go
go mod tidy
```

Usage:
```go
package main

import (
    "fmt"
    "log"
    "myembeddeddb"
)

func main() {
    db, err := myembeddeddb.NewDatabase()
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    // Store data
    err = db.Put("hello", []byte("world"))
    if err != nil {
        log.Fatal(err)
    }

    // Retrieve data
    value, err := db.Get("hello")
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("Value: %s\\n", value)

    // Check existence
    exists, err := db.Exists("hello")
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("Key exists: %t\\n", exists)
}
```

### JavaScript/Node.js

```bash
cd bindings/js
npm install
```

Usage:
```javascript
const { Database } = require('my-embedded-db');

// Create an in-memory database
const db = Database.create();

try {
    // Store data
    db.put('hello', 'world');

    // Retrieve data
    const value = db.getString('hello');
    console.log('Value:', value); // Value: world

    // Check existence
    if (db.exists('hello')) {
        console.log('Key exists!');
    }

    // Get database size
    console.log('Database has', db.length, 'items');
} finally {
    db.close();
}
```

## API Reference

All language bindings provide the same core functionality:

### Database Creation
- **In-memory**: `Database()` / `NewDatabase()` / `Database.create()`
- **File-based**: `Database(path)` / `OpenDatabase(path)` / `Database.open(path)`

### Core Operations
- **put(key, value)**: Store a key-value pair
- **get(key)**: Retrieve a value by key (returns null/nil if not found)
- **delete(key)**: Remove a key (returns boolean indicating if key existed)
- **exists(key)**: Check if a key exists
- **clear()**: Remove all data
- **close()**: Close the database and free resources

### Properties
- **length/len()**: Get the number of key-value pairs
- **isEmpty()**: Check if the database is empty

## Error Handling

All bindings provide proper error handling:

- **Python**: Raises `DatabaseError` exceptions
- **Go**: Returns `error` values with detailed messages
- **JavaScript**: Throws `DatabaseError` exceptions

## Performance Considerations

- All operations are thread-safe (Rust core uses `Arc<RwLock<...>>`)
- For better performance in real applications, consider using:
  - RocksDB for persistent storage with LSM-tree performance
  - LMDB for memory-mapped file access
  - Custom implementations for specific use cases

## Development

### Running Tests

```bash
# Rust tests
cargo test

# Python tests (after installing the package)
cd bindings/python
python -m pytest tests/

# Go tests
cd bindings/go
go test

# JavaScript tests
cd bindings/js
npm test
```

### Contributing

1. Make changes to the core Rust library in `crates/db_core/`
2. Update the FFI layer in `crates/db_ffi/` if needed
3. Rebuild with `cargo build --release -p db_ffi`
4. Test all language bindings
5. Update documentation as needed

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Roadmap

- [ ] Add support for transactions
- [ ] Implement iterators for key scanning
- [ ] Add compression support
- [ ] Implement persistent storage backends (RocksDB, LMDB)
- [ ] Add async/await support for JavaScript
- [ ] Create C# and Java bindings
- [ ] Add benchmarks and performance tests
- [ ] Implement backup and restore functionality