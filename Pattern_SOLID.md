# SOLID Principles in Java

## 1. Single Responsibility Principle (SRP)
*A class should have only one reason to change — not "only one method".*

```java
// BAD: Invoice handles both business logic AND printing/persistence
class Invoice {
    double calculateTotal() { /* ... */ return 100.0; }
    void printInvoice() { /* printing logic */ }
    void saveToDB() { /* DB logic */ }
}

// GOOD: each class has one reason to change
class Invoice {
    double calculateTotal() { /* ... */ return 100.0; }
}
class InvoicePrinter {
    void print(Invoice invoice) { /* printing logic */ }
}
class InvoiceRepository {
    void save(Invoice invoice) { /* DB logic */ }
}
```
`Invoice` can still have multiple methods (`calculateTotal`, `applyDiscount`, `getItems`) — that's fine, they all change for the *same reason* (billing logic changes).


## 2. Open/Closed Principle (OCP)
*Open for extension, closed for modification.*

```java
interface PaymentMethod {
    void pay(double amount);
}

class CreditCardPayment implements PaymentMethod {
    public void pay(double amount) { System.out.println("Paid via Credit Card: " + amount); }
}

class UpiPayment implements PaymentMethod {
    public void pay(double amount) { System.out.println("Paid via UPI: " + amount); }
}

// Adding PayPal later requires NO change to existing classes
class PayPalPayment implements PaymentMethod {
    public void pay(double amount) { System.out.println("Paid via PayPal: " + amount); }
}

class PaymentProcessor {
    void process(PaymentMethod method, double amount) {
        method.pay(amount); // works with any implementation
    }
}
```


## 3. Liskov Substitution Principle (LSP)
*A subclass object should be substitutable for its parent without breaking correctness.*

```java
// BAD: violates LSP — Ostrich can't fly, but is forced to implement fly()
class Bird {
    void fly() { System.out.println("Flying"); }
}
class Ostrich extends Bird {
    void fly() { throw new UnsupportedOperationException(); } // breaks substitution!
}
```

Fix: don't force behavior onto subclasses that can't honor it — split the abstraction.

```java
interface Bird {
    void eat();
}
interface FlyingBird extends Bird {
    void fly();
}

class Sparrow implements FlyingBird {
    public void eat() { System.out.println("Eating"); }
    public void fly() { System.out.println("Flying"); }
}

class Ostrich implements Bird {
    public void eat() { System.out.println("Eating"); }
    // no fly() forced on it — LSP preserved
}
```
Now any `Bird` reference works safely with any subtype, and only `FlyingBird`s are expected to fly.


## 4. Interface Segregation Principle (ISP)
*Clients shouldn't be forced to depend on methods they don't use — prefer many small interfaces over one fat interface.*

```java
// BAD: fat interface
interface Machine {
    void print();
    void scan();
    void fax();
}
class OldPrinter implements Machine {
    public void print() { System.out.println("Printing"); }
    public void scan() { throw new UnsupportedOperationException(); } // forced, unused
    public void fax()  { throw new UnsupportedOperationException(); } // forced, unused
}

// GOOD: segregated interfaces
interface Printer { void print(); }
interface Scanner { void scan(); }
interface Fax     { void fax(); }

class OldPrinter implements Printer {
    public void print() { System.out.println("Printing"); }
}
class AllInOnePrinter implements Printer, Scanner, Fax {
    public void print() { System.out.println("Printing"); }
    public void scan()  { System.out.println("Scanning"); }
    public void fax()   { System.out.println("Faxing"); }
}
```
This is exactly the fix you mentioned under LSP too — a child not wanting all parent methods is a *symptom* that the interface needs to be segregated in the first place.


## 5. Dependency Inversion Principle (DIP)
*High-level modules shouldn't depend on low-level modules — both should depend on abstractions. (Not "Dependency Injection", though DI is the common technique used to achieve it.)*

```java
// BAD: high-level class directly depends on low-level concrete class
class MySqlDatabase {
    void save(String data) { System.out.println("Saved to MySQL: " + data); }
}
class UserService {
    private MySqlDatabase db = new MySqlDatabase(); // tightly coupled
    void saveUser(String user) { db.save(user); }
}

// GOOD: both depend on an abstraction
interface Database {
    void save(String data);
}
class MySqlDatabase implements Database {
    public void save(String data) { System.out.println("Saved to MySQL: " + data); }
}
class MongoDatabase implements Database {
    public void save(String data) { System.out.println("Saved to MongoDB: " + data); }
}

class UserService {
    private final Database db; // depends on abstraction, not concrete class
    UserService(Database db) { this.db = db; } // injected (constructor injection)
    void saveUser(String user) { db.save(user); }
}

// usage
UserService service = new UserService(new MongoDatabase()); // swap freely, no code change in UserService
```

### Quick mental map
| Principle | One-liner |
|---|---|
| SRP | One reason to change |
| OCP | Extend without modifying |
| LSP | Subtypes must honor supertype's contract |
| ISP | Small, focused interfaces |
| DIP | Depend on abstractions, not concretions |

---------------------------------------------------------------------------
Factory:
All notification logic should be present in the factory and client should talk only to that class, object creating logic should not be present in client class


EmailNotification - void send() println()
SMSNotification - void send() println()

OrderService - new of both() and send()

Voilation 1: Tight coupling

Create common interface Notification with send() and implement it

OrderService - Notification 
sendNotification(type){
  .....
  notification.send();
}

Voilation 2: DRY violation for another client we have to write same sendNotification code

shift that logic to NotificationFactory
NotificationFactory.sendNotification("EMAIL");

can also have logic to send all notification using List<Notification>

------------------------------------------------------------------------
Singleton:
Only one instance of class should exist across the application

Main(){
Calculator c1 = new Calculator();
Calculator c2 = new Calculator();
c1.a = 10;
c1.b = 12;
c2.a = 13;
c2.b = 14;
}

Basic Implementation:
Calculator{
  int a, b;
  private static Calculator obj = new Calculator();
  public static Calculator getInstance(){
  return obj;
  }
}

Main(){
Calculator c1 = Calculator.getInstance();
Calculator c2 = Calculator.getInstance();
}

Violation 1: Wasting memory because the object is already present (Eager initialization)


Calculator{
  int a, b;
  private static Calculator obj;
  public static Calculator getInstance(){
    return new Calculator();
  }
}

Violation 2: It will create new objects each time 

//Lazy initialization 
Calculator{
  int a, b;
  private static Calculator obj;
  public static Calculator getInstance(){
    if(obj == null) obj = new Calculator();
    return obj;
  }
}

Violation 3: for multiple threads it will still create new multiple instance
static = shared by all instances
still multithreads can access it and modify it at same time
solution : locking mechanism, one at a time

Calculator{
  int a, b;
  private static Calculator obj;
  public synchronized static Calculator getInstance(){
    if(obj == null) obj = new Calculator();
    return obj;
  }
}

Violation 4: even object is created once, every thread has to wait for lock

Double check Locking mechanism 

  public static Calculator getInstance(){
    if(obj == null) {
      synchronized (Calculator.class){
           if(obj == null) {
                obj = new Calculator();
            }
        }
     }
    return obj;
  }

Logging system, DB connection manager, Configuration Manager
--------------------------------------------------------------------------


