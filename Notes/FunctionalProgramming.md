# Functional Programming Fundamentals

- Lambda expressions
- Functional interfaces
- Effectively final variables

## Built-in Functional Interfaces

- Predicate
- Function
- Consumer
- Supplier
- Default methods of functional interfaces

## Stream API Fundamentals

- Stream processing pipeline:
  - Source
  - Intermediate operations
  - Terminal operation
- Lazy evaluation

## Stream Operations

- `filter()`
- `map()`
- `flatMap()`
- `sorted()`
- `distinct()`
- `reduce()`

## Collectors

- `groupingBy()`
- `partitioningBy()`
- `toMap()`
- `counting()`
- `joining()`

## Optional and Primitive Streams

- Null handling using `Optional`
- Avoiding unnecessary boxing
- Primitive streams:
  - `IntStream`
  - `LongStream`
  - `DoubleStream`

## Parallel Streams

- ForkJoinPool
- Shared mutable state
- Performance trade-offs
- Sequential vs. parallel streams

## Interview Practice

Practice real-world problems involving employees, products, transactions, and order processing.

### Employee-Based Problems

1. Filter employees based on salary or department.
2. Convert a list of employees into a list of names.
3. Find the highest-paid employee.
4. Group employees by department.
5. Count employees in each department.
6. Find the second-highest salary.

### Collection-Based Problems

7. Find duplicate elements in a list.
8. Convert a list of lists into a single list.
9. Convert a list into a `Map`.

### Optional-Based Problems

10. Handle null values using `Optional`.
