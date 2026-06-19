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

### Query Derivation/Method:
```
Query methods (naming should follow Spring Data JPA rules):
User findByEmail(String email)
List<User> findByNameAndAge(String name, int age)
List<User> findByNameContaining(String name)

--- Common words ---
Containing / StartingWith / EndingWith (maps to SQL LIKE)
IgnoreCase (maps to UPPER(field) = UPPER(?))
GreaterThan / LessThan / Between
True / False (for boolean logic)
```

### JPQL
```
JPQL works on objects not tables because JPA wants application to database-independent so we don't have to 
modify queries for different DBs, hibernate deals with it internally
@Query(
"SELECT u FROM User u WHERE u.email=?1"
)
User getUser(String email);
```

### Relationship
```
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

### For Associations/Joins
```
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



### Pagination, Sorting, Slicing
```
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

### Projections
```
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

### Hibernate
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

### Database
```
in application.yml while configuring DB:
spring.jpa.hibernate.ddl-auto - controls whether Hibernate should create/update/validate tables based on your @Entity classes.
✅ none - do nothing
✅ validate - hibernate checks if entity mappings matches DB
⚠️ Update - Hibernate modifies the database schema to match entities.
⚠️ create - drops previous tables, create new tables
⚠️ create-drop - drop tables, create new tables then while shutting drop tables
```

### Transaction
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
### Anomalies
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

## Annotations
Annotations in Spring Boot act as metadata, providing instructions to the Spring container on how to discover, configure, 
and wire Java objects


### Stereotype Annotations
```
Stereotype annotations are applied to classes to designate their specific role within the application architecture.
When Spring runs its Component Scan, it detects these annotations and automatically registers the classes as managed
Spring Beans.

1. @Component - The generic root stereotype for any Spring-managed component
2. @Service - Business Logic Layer
3. @Repository - Data Access Layer
4. @Controller - Web Controller handling traditional server-side web interfaces, method typically returns string which is
                 name of web view template to be rendered by server
5. @RestController - specific for RESTful web services, combines @Controller and @ResponseBody, so instead of view template
                     file, method return data directly into HTTP response body (via Jackson)
6. @Autowired - Inject matching dependency into this
```

### Configuration Annotations
```
Configuration annotations instruct Spring on how to initialize the container engine, declare externalized properties,
toggle environments, and manually manufacture third-party beans.

1. @SpringBootApplication - main entry-point class of every Spring Boot app
2. @Configuration - class contains 1 or more methods to be managed by Spring container
3. @Bean - Register method and return value as bean inside container
4. @EnableAutoConfiguration - Instructs spring boot to inspect pom.xml or build.gradle build configuration and initialize beans.
5. @ComponentScan - specify base java package where spring should scan incase main class is outside structure
6. @Value - inject properties from external environment sources directly into fields in your beans.
7. @ConfigurationProperties - Binds entire block of properties into strongly type object, better than using many @Values
8. @Profile - Activates/Deactivates beans based on environment profile
```

### Dependency Injection Annotations
```
When your application context contains many beans, Spring needs explicit instructions on how to resolve
dependencies—especially when multiple beans implement the exact same interface.

1. @Autowired - tells IoC container to find and inject matching bean into the target class 
2. @Qualifier - Qualifies 1 between multiple beans of same data type
3. @Primary - Sets 1 as default choice when multiple beans of same type exists
```

### Web / REST Annotations
```
Web annotations turn plain Java classes into powerful, HTTP-aware controllers capable of extracting raw web payloads,
handling query parameters, and returning structured JSON.

1. @RestController - Restful web controller
2. @RequestMapping - Configures structural routing paths, HTTP methods, headers, and media types for a controller.
3. @GetMapping - Fetches or reads a resource.
4. @PostMapping - Creates a new resource.
5. @PutMapping - Completely replaces an existing resource.
6. @DeleteMapping - Removes a specific resource.
7. @PatchMapping - Applies a partial modification to a resource.
8. @PathVariable - Extracts data parameter from URI path
9. @RequestParam - Extracts query parameter after ?
10. @RequestBody - Deserialize JSON body to Java object
11. @ResponseStatus - predefined HTTP status code returned automatically when controller method completes/exception is triggered.
```

### Validation Annotations
Data validation should happen at the absolute entry point of your application (the Controller). 
Spring Boot uses Jakarta Bean Validation to inspect incoming payloads before your business logic ever touches them.
| Annotation | Target | Rule |
|---|---|---|
| `@NotNull` | Any | Cannot be null (`""` and `[]` allowed) |
| `@NotEmpty` | String, Collection, Array | Cannot be null or empty |
| `@NotBlank` | String | Cannot be null, empty, or only spaces |
| `@Size` | String, Collection, Array | Length/size must be within min-max |
| `@Min` | Numbers | Value must be >= given minimum |
| `@Email` | String | Must be valid email format |
| `@Pattern` | String | Must match given regex |

### JPA / Hibernate Annotations
JPA (Java Persistence API) annotations map plain old Java objects (POJOs) directly to relational database tables.
| Annotation | Purpose |
|---|---|
| `@Entity` | Marks class as a database entity. Requires no-arg constructor and primary key |
| `@Table` | Defines SQL table name (default = class name) |
| `@Id` | Marks field as primary key |
| `@GeneratedValue` | Auto-generates primary key values |
| `@Column` | Customizes column details (name, nullable, length, etc.) |
| `@Transient` | Excludes field from database mapping |
| `@OneToOne` | Maps 1:1 relationship |
| `@ManyToOne` | Many entities → one entity relationship |
| `@OneToMany` | One entity → collection of entities |
| `@ManyToMany` | Many-to-many relationship using join table |
| `@JoinColumn` | Defines foreign key column for relationship |

### Transaction Annotation
```
Control transaction boundaries and handling non-standard data modifications
1. @Transactional - Declares that an entire method execution block must occur within a safe, isolated database transaction boundary.
2. @Modifying - Instructs Spring Data JPA that a custom query written with @Query is a DML (Data Manipulation Language) statement
                (an UPDATE, DELETE, or INSERT) rather than a standard SELECT lookup query.
```

### AOP Annotations
AOP (Aspect-Oriented Programming) = a way to add common logic to multiple methods without writing the same code everywhere.
| Annotation | Role | Timing |
|---|---|---|
| `@Aspect` | Defines an AOP class containing cross-cutting logic | Container |
| `@Pointcut` | Defines methods to intercept | Target selection |
| `@Before` | Runs before target method | Before execution |
| `@After` | Runs after method (success/failure) | Finally block style |
| `@AfterReturning` | Runs after successful execution, can access return value | On success |
| `@AfterThrowing` | Runs when exception occurs, can access error | On failure |
| `@Around` | Wraps method execution, full control over call | Before + after |

### Scheduling / Async Annotations
```
Web requests in Spring Boot execute sequentially on a single worker thread
this annotations allow to shift workloads to background task executor and thread pools

1. @EnableScheduling - placed on main/config class to activate scheduling infrastructure without it @scheduled methods will be
                       ignored
2. @Scheduled - runs method automatically at designated time intervals
                configuration - fixedRate, fixedDelay, cron
3. @EnableAsync - placed on configuration class to enable async processing and set up internal background thread pools
4. @Async - runs method in separate worker thread, when controller calls @Async method, it immediately returns 202 Accepted back
            without waiting for task to be finished.
```

### Testing Annotations
Spring Boot handles testing using Test Slices. Instead of forcing you to load your entire application context, database layers, 
and web servers for a simple test, Spring provides targeted annotations to spin up only the exact infrastructure you need.

| Annotation | Purpose |
|---|---|
| `@SpringBootTest` | Loads the full Spring application context (almost like running the app) |
| `@WebMvcTest` | Loads only MVC/web layer (`DispatcherServlet`, controllers, MVC configs, filters if included) |
| `@DataJpaTest` | Loads JPA layer (`Entity`, repositories, Hibernate, test database config) |
| `@MockitoBean` | Registers a Mockito mock as a Spring bean inside the application context |
| `@AutoConfigureMockMvc` | Configures `MockMvc` to test controllers without starting a real server |
