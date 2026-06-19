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
Query methods (naming should follow Spring Data JPA rules):
User findByEmail(String email)
List<User> findByNameAndAge(String name, int age)
List<User> findByNameContaining(String name)
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
