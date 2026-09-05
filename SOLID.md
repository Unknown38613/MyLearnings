SOLID:
Single Responsibility Principle : Class should have only one reason to change doesn't mean one method
Solution : Split the multiple resource/service related logic in different classes

Open/Close Principle : Class should be open for extension and close for modification
Doesn't mean class can't be modified permanently but while adding functionality we should be able to add it without breaking current one
Solution: Make a common interface and let additional functionality implement it

Liskov's substitution principle : 
If child class is extending parent class/interface so the any class that want to use the parent should be able to use child class instead completely (Basic Inheritance) 
But if suppose child class extends parent and doesn't fully support the behavior of parent like one method of parent class cannot be implemented in child then we can't fully replace parent with child so principle fails
Solution: Don't force the inheritance relationship at all if the child can't honor the parent's contract, ISP is one fix for it

Interface Segregation Principle :
Don't force child to implement methods that doesn't belong to that parent, same like Liskovs
Create separate interfaces and Java supports multiple inheritance for interfaces
Solution : Break the fat interface in different interfaces 

Then what is the difference : 
ISP : Contract itself
LSP: Does it honor the contract?

Dependency Inversion Principle:
Make classes loosely coupled, high-level modules shouldn't depend on low-level modules — both should depend on abstractions
Solution: One technique - DI: Create common constructor and instead of directly initializing with new keyoword use constructor injection, setter injection etc 
