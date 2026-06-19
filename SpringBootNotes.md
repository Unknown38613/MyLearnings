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

orphanRemoval = true - if child is removed from parent's collection, delete that child from DB, without this the
row remains in DB
```

> Connection Pooling (Spring uses Hikari CP) - maintains cache of active DB connections that are shared and resued among incoming threads instead of doing TCP handshakes, auth, etc everytime with DB, when application starts connection pool instantiates fixed no. of connections, when spring service needs to interact with DB, it borrows idle connection from Pool, when operation is completed connection is returned back to pool instead of closing it.

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
## Database
```
in application.yml while configuring DB:
spring.jpa.hibernate.ddl-auto - controls whether Hibernate should create/update/validate tables based on your @Entity classes.
✅ none - do nothing
✅ validate - hibernate checks if entity mappings matches DB
⚠️ Update - Hibernate modifies the database schema to match entities.
⚠️ create - drops previous tables, create new tables
⚠️ create-drop - drop tables, create new tables then while shutting drop tables
```

## Transaction
```
@Transactional - Spring doesn't execute your code directly. Instead, it wraps your bean in an
Aspect-Oriented Programming (AOP) Dynamic Proxy and creates Proxy object, then the proxy handles DB connections, DB commits,
DB rollbacks.
⚠️ It only rollbacks for unchecked (runtime) exceptions, for checked it will still commit so
do @Transactional(rollbackFor = {Exception.class, CustomCheckedException.class})

✅ At class level @transactional works fine but don't do it usually because it creates extra overhead

⚠️ At method level:
If a non-transactional method tried to access transactional method then it does create proxy but doesn't go through proxy,
doesn't do transaction, runs normally
so to fix it move transactional method to another service.

Spring = transaction manager (BEGIN, COMMIT, ROLLBACK)
Hibernate = ORM + change tracker (Entity tracker, Dirty Checking, Flushing changes)
```
## Anomalies
```
Concurrency Anomalies:
Dirty Read: A updates no commit, B reads updated data, A roll back, B contains dirty data that never existed

Non-repeatable Read: A reads row, B reads row, updates it and commit, A reads row again and see different data

Phantom Read: A executes read range query, B inserts new row and commits, A executes same query and see new phantom row

specify isolation level @Transactional(isolation = Isolation.REPEATABLE_READ):
DEFAULT: matches with DB provider like postgres default READ_COMMITTED, MySQL default REPEATABLE_READ
READ_UNCOMMITTED : All allowed, fastest
READ_COMMITTED : Dirty read not allowed 
REPEATABLE_READ : Dirty read and Non-repeatable read not allowed
SERIALIZABLE : All not allowed, slowest
```
