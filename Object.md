1)

main stack myCar -> 0x0010 heap

changeColor stack myCar -> 0x0010 heap (copies from main)

myCar.color = "Red" (gets changed in heap)

2)

main stack myCar -> 0x0010 heap

replaceCar stack myCar -> 0x0010 heap (copies from main)

replaceCar stack myCar -> 0x0020 heap

but main stack myCar is untouched


now in scenario 1 suppose we don't want that anyone else should be able to modify the object in heap then what to do : private final (immutable without setters)
also if we want to pass completely same but different object then what to do (deep copy using copy constructor)

in scenario 2, how does instance variable and static variable will act (if passed as parameter then same stack will create own copy, but if reassigned directly then heap will change 
