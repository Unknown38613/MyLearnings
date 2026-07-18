Single Responsibility Principle (SRP):
A class should have only one reason to change, doesn't mean only one method

Open/Close Principle (OCP):
Open for extension, close for modification
Example common interface for different types of payment

Liskov's Substitution Principle (LSP):
If child class extends parent class then we can replace the parent object with child object without breaking application
Obvious but the problem is when a child class doesn't want to implement all methods of parent class, so create interface for that particular case

Interface Segregation Principle (ISP):
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


