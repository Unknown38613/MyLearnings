## Adapter Pattern

Client accepts different method for same functionality but 3rd party has different method.
One way is to directly implement 3rd party interface in client class by modifying it to return client preferable result.
But it creates tight coupling and when multiple 3rd party has different interfaces then it will create mess.

**Solution:**

1. Make a client interface with method which client accepts
2. Create 3rd party Adapter class that implements the client interface
3. Create instance of the 3rd party class in the adapter
4. Override the client interface method and make necessary changes to adjust that 3rd party according to client's method
5. For another 3rd party create another adapter

* **Adapter** IS-A **Client Interface**
* **Adapter** HAS-A **Third-Party Class**



## Decorator Pattern

Adding behavior/functionalities to object dynamically without needing to modify original class.
Without it, for each additional functionality you would have to create separate classes.

**Solution:**

1. Make common interface (component) with methods that is required by default
2. Make a common abstract Decorator class which implements the common interface and has Object reference for the interface as well (both IS-A, and HAS-A)
with constructor that initialize the object
3. Now create concrete Decorator for the additional behavior/functionalities by extending common decorator class, which will override the common interface
methods and modify the method with it's own behavior which it want and the constructor will call the parent class constructor by passing the object to `super(obj)`
such that the original object will get changed and the behavior/functionality will get added to original object dynamically

* **Abstract Decorator** IS-A **Component Interface**
* **Abstract Decorator** HAS-A **Component Interface**
* **Concrete Decorator** IS-A **Abstract Decorator**
* **Concrete Decorator** IS-A **Component Interface**



## Observer Pattern

One object automatically notifies multiple objects when any change or event occurs.

**Solution:**

1. Create a concrete class(subject) which has subscriber list (keep the subscriber generic by creating interface with common update method for loose coupling)
2. Create methods that will trigger the change and create notify method that will notify subscribers in concrete class
3. Now create different subscriber classes that will implement subscriber interface
4. Since subscriber is generic just pass the `"this"` reference to update method in concrete class so it will go to different subscribers update method allowing them to access modified state

* **Different Subscribers** IS-A **Subscriber**
* **Subject** HAS-A `List<Subscriber>`
