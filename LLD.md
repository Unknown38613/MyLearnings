# LLD Patterns & System Design Practice Roadmap

## LLD Design Patterns

### Basics

- Singleton
- Factory
- Builder


## Behavioural Patterns

- Strategy
- Observer
- State


## Structural Patterns

- Decorator
- Adapter
- Proxy


## Advanced Flow Control Patterns

- Command
- Chain of Responsibility


## Bonus Pattern

- Prototype


# Must Know Patterns

These patterns should be implemented and understood deeply:

- Singleton
- Factory
- Strategy
- Observer


# LLD Machine Coding / Design Problems

Practice implementing these systems:

## 1. Parking Lot System

Concepts:
- Object modeling
- Factory pattern
- Strategy pattern
- Parking allocation logic
- Vehicle types
- Slot management


## 2. Library Management System

Concepts:
- Entity relationships
- Book management
- Member management
- Issue/Return flow
- Fine calculation


## 3. Movie Ticket Booking System

Concepts:
- Seat allocation
- Booking flow
- Concurrency handling
- Payment workflow
- Locking mechanism


## 4. LRU Cache

Concepts:
- HashMap
- Doubly Linked List
- O(1) get/put operations
- Eviction policy


## 5. Snake and Ladder Game

Concepts:
- Board modeling
- Dice strategy
- Player movement
- Game state management


## 6. Splitwise

Concepts:
- Expense management
- Balance calculation
- Simplification algorithm
- Strategy pattern


## 7. Elevator System

Concepts:
- State pattern
- Scheduling algorithm
- Elevator movement strategy
- Request handling


## 8. Notification System

Concepts:
- Observer pattern
- Factory pattern
- Multiple notification channels

Examples:
- Email
- SMS
- Push Notification


## 9. Rate Limiter

Concepts:
- Token Bucket
- Leaky Bucket
- Fixed Window
- Sliding Window
- Concurrency handling


## 10. Food Delivery System

Concepts:
- Order lifecycle
- State pattern
- Delivery assignment
- Payment handling
- Notification system


# Follow-up Interview Questions

## Concurrency Handling

Understand:

- Thread safety
- Race conditions
- Critical sections
- Locks
- Synchronization
- Atomic operations
- Immutable objects
- Concurrent collections


Important topics:

- synchronized keyword
- ReentrantLock
- ReadWriteLock
- Semaphore
- CountDownLatch
- CyclicBarrier
- Atomic classes


## Multithreading Handling

Understand:

- Thread lifecycle
- Thread creation
- Runnable vs Callable
- ExecutorService
- Thread pools
- Future and CompletableFuture
- Producer Consumer pattern
- Deadlock prevention
- Thread communication


## Common LLD Concurrency Questions

- How will you make Singleton thread safe?
- How will you handle multiple users booking the same seat?
- How will you make LRU Cache thread safe?
- How will you prevent double payment?
- How will you handle concurrent elevator requests?
- How will you design a thread-safe rate limiter?
