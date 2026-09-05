# SOLID Principles

## 1. Single Responsibility Principle (SRP)

> **A class should have only one reason to change.**

This **doesn't mean a class should have only one method**.

The idea is that a class should have **one responsibility**.

### Problem

If a class contains multiple unrelated responsibilities, a change in one responsibility can affect the others.

### Solution

Split different resource/service-related logic into separate classes.

---

## 2. Open/Closed Principle (OCP)

> **A class should be open for extension but closed for modification.**

This doesn't mean the class can **never** be modified.

It means that when adding new functionality, we should preferably be able to **extend the existing behavior without modifying and potentially breaking the existing code**.

### Solution

Create a common interface and let additional functionality implement that interface.

For example:

```java
interface Payment {
    void pay();
}
```

Different payment methods can implement the interface:

```java
class CreditCardPayment implements Payment {
    public void pay() {
        // Credit card payment
    }
}

class UPIPayment implements Payment {
    public void pay() {
        // UPI payment
    }
}
```

Now adding a new payment method doesn't require modifying the existing implementations.

---

## 3. Liskov Substitution Principle (LSP)

> **If a child class extends a parent class/interface, the child should be usable wherever the parent is expected without breaking the expected behavior.**

This is more than simply having an inheritance relationship.

### Problem

Suppose a child class extends a parent class but **cannot properly support the behavior promised by the parent**.

Then the child cannot completely replace the parent, and the principle is violated.

### Example

```java
class Bird {
    void fly() {
        // fly
    }
}

class Penguin extends Bird {
    @Override
    void fly() {
        throw new UnsupportedOperationException();
    }
}
```

A `Penguin` technically extends `Bird`, but it cannot honor the behavior expected from `Bird`.

Therefore:

```java
Bird bird = new Penguin();
bird.fly(); // Problem
```

### Solution

Don't force an inheritance relationship if the child cannot honor the parent's contract.

**ISP can often help solve this problem** by breaking a large interface/abstraction into smaller ones.

---

## 4. Interface Segregation Principle (ISP)

> **Clients should not be forced to depend on methods they do not use.**

In simple terms:

> Don't force a class to implement methods that don't belong to it.

### Problem

A large **"fat interface"** may contain many methods, but some implementing classes may need only a few of them.

### Solution

Break the fat interface into smaller, more focused interfaces.

For example, instead of:

```java
interface Worker {
    void work();
    void eat();
}
```

we can have:

```java
interface Workable {
    void work();
}

interface Eatable {
    void eat();
}
```

A class can implement only the interfaces it actually needs.

Java also allows a class to implement **multiple interfaces**, which makes this approach practical.

---

## ISP vs LSP

A simple way to remember the difference:

| Principle | Main Question                                               |
| --------- | ----------------------------------------------------------- |
| **ISP**   | Is the contract itself properly designed?                   |
| **LSP**   | Does the child/implementation actually honor that contract? |

### Easy way to remember

**ISP → Don't create a bad/too-large contract.**

**LSP → If you accept the contract, you must honor it.**

---

## 5. Dependency Inversion Principle (DIP)

> **High-level modules should not depend directly on low-level modules. Both should depend on abstractions.**

The goal is to make classes **loosely coupled**.

### Problem

If a high-level class directly creates and depends on a concrete implementation:

```java
class OrderService {
    private PaymentService paymentService = new PaymentService();
}
```

`OrderService` is tightly coupled to `PaymentService`.

Changing the implementation requires changing `OrderService`.

### Solution

Depend on an abstraction instead:

```java
interface PaymentService {
    void pay();
}
```

```java
class OrderService {

    private final PaymentService paymentService;

    OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

Now `OrderService` doesn't care which concrete implementation it receives.

### Dependency Injection

**Dependency Injection (DI)** is one technique used to achieve this.

Instead of creating dependencies directly using `new`, provide them from outside.

Common forms include:

* **Constructor Injection**
* **Setter Injection**
* **Field Injection**

Constructor injection is generally preferred because the dependency is explicit and can be made immutable.

---

# Quick Revision

| Principle | Remember This                                         |
| --------- | ----------------------------------------------------- |
| **SRP**   | One class → one responsibility / one reason to change |
| **OCP**   | Add new behavior without breaking existing code       |
| **LSP**   | Child should be able to replace parent                |
| **ISP**   | Don't force classes to implement unnecessary methods  |
| **DIP**   | Depend on abstractions, not concrete implementations  |

### One-line memory trick

**S** → **Single responsibility**

**O** → **Open for extension**

**L** → **Leave parent behavior intact when substituting child**

**I** → **Interfaces should be small**

**D** → **Depend on abstractions**
