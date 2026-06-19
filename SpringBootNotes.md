# Spring Boot Notes

## Core:
```
IoC concept -> IoC container concept -> BeanFactory (base container) -> Applicationcontext (extend from base)
DI (Way to achieve IoC, not the only way)
```

## MVC:
```
Base case without DTO
Client request (json) -> DispatcherServlet does 2 things
a -> handlermapping (find controller)
b -> HttpMessageConverter (Jackson - json to java object) 
a + b -> controller -> service (process) -> controller -> Jackson (java object to json) -> DispatcherServlet -> Client
```

```
If Jackson sees @RequestBody UserRequestDTO then:
Client request (json) -> DispatcherServlet does 2 things
a -> handlermapping (find controller)
b -> Jackson (json to DTO) 
a + b -> controller -> service (process) -> controller -> Jackson (DTO to json) -> DispatcherServlet -> Client
```

```
If we include database too then:
Client request (json) -> DispatcherServlet does 2 things
a -> handlermapping (find controller)
b -> Jackson (json to java object) 
a + b -> controller -> service (convert DTO to entity) -> Repository -> Database 

Database (gives entity) -> service (entity to DTO) -> controller -> Jackson (DTO to json) -> DispatcherServlet -> Client
```

```
Without ResponseEntity<> we just control the data, with that we can control status codes, headers along with data.
```


### Request Processing:
```
Client request -> Filters (part of Java Servlet specification (jakarta.servlet.Filter) outside of spring framework,
CORS, auth, login, request modification) ->  DispatcherServlet 
```
```
Interceptors - part of spring MVC
1. Register the interceptor (knows full about beans and controllers)
2. Client Request -> DispatcherServlet -> Interceptor (preHandle()) -> Controller -> Service (process) -> Controller ->
Interceptor (postHandle()) -> Interceptor (afterCompletion)) -> Dispatcherservlet -> Client
```

## JPA
```
JPA - specification
Hibernate - Implementation
Entity - class that represents DB table through which hibernate understands
```

```
interface UserRepo extends JpaRep<User, Long>{}
automatically we get findById(), findAll(), save(), deleteByID(), count(),
hibernate convert them into SQL queries
```
```
Query Derivation / Query methods (naming should follow Spring Data JPA rules):
User findByEmail(String email)
List<User> findByNameAndAge(String name, int age)
List<User> findByNameContaining(String name)

--- Common words ---
Containing / StartingWith / EndingWith (maps to SQL LIKE)
IgnoreCase (maps to UPPER(field) = UPPER(?))
GreaterThan / LessThan / Between
True / False (for boolean logic)
```

```
JPQL works on objects not tables because JPA wants application to database-independent so we don't have to 
modify queries for different DBs, hibernate deals with it internally
@Query(
"SELECT u FROM User u WHERE u.email=?1"
)
User getUser(String email);
```
```
Relationship:
1 user can have many orders so:

@Entity
class User{

@OneToMany(mappedBy="user")
List<Order> orders;
}

@Entity
class Order{

@ManyToOne
User user;
}

**mappedBy = "I am not the owner, I am mapped by the other side."**

mappedBy="user" means hibernate don't create a join table for managing relationship,
it has already a relation on other side which is "user"
```

```
Usually for Associations/Joins:
Eager loading:
@OneToMany(fetch=FetchType.EAGER) get user along with all orders
Lazy Loading : 
@OneToMany(fetch=FetchType.LAZY) get user first then orders will be fetched when asked

Cascading - whether the same operation should be performed on child entity
@OneToMany(mappedBy = "customer", cascade = CascadeType.ALL, orphanRemoval = true)
private List<Address> addresses = new ArrayList<>();

cascade = CascadeType.REMOVE - if parent deleted, delete children too
so it will delete child first, then parent

orphanRemoval = true - if child is removed from parent's collection, delete that child from DB, without this the row remains in DB
```

```
Pagination, Sorting, Slicing:

Offset Pagination:
Page = 3 & Size = 10 means skip 30 records and give next 10 (slow for huge data)
Cursor/ KeySet pagination:
Cursor = 102 & Size = 10 means give 10 records after this 102 ID (DB's are optimized for finding B-Tree Index O(log n))


Pageable pageable = PageRequest.of(offset - 0, number of records - 10);
Page<Employee> employees =
        employeeRepository.findAll(pageable);


For Sorting:
Sort sort = Sort.by("name").ascending();

For both:
 PageRequest.of(
        0,
        10,
        Sort.by("salary").descending()
    );

With Query Derivatives/ Method:
Page<Employee> findByDepartment(
        String dept,
        Pageable pageable
);


Page = data + total count
Slice = data + tell if there is more (it fetches 1 more if true else false)
```

```
Projections:
Fetch the fields/columns you need instead of entire entity

Interface based:
Create Entity : Employee with all fields
Create interface: EmployeeView with required field
Now query derivative/method in repo : List<EmployeeView> findBySalary(int salary)

DTO based:
create DTO instead of interface
then in repo : @Query("..") List<EmployeeDTO> getEmployees();

Closed same as interface, select only needful

Open same as interface but 
 @Value("#{target.name + ' ' + target.department}")
    String getDetails();
but now it requires entity
```

## Hibernate
```
Hibernate manages state of object inside it:
Transient - obj exists, but hibernate doesn't know it
Persistent (.save()) - put's that in persistence context and now it notices the changes (dirty checking) and will
                       update that at commit.
Detached (.close()) - object still exist but hibernate no longer watch it
Removed (.delete()) - will delete the object at commit.

Spring starts DB transaction -> Persistence context opens -> Hibernate executes SQL -> Hibernate creates entity object ->
object becomes persistent -> modify the object -> Hibernate dirty checks detect change -> Transaction ends ->
Hibernates flushes SQL -> DB COMMIT -> Persistence context close 

@Transactional does not directly open Hibernate's persistence context. It tells Spring to create a transaction boundary.
As part of that, Spring usually creates/binds a Persistence Context (EntityManager) that Hibernate uses.
```
