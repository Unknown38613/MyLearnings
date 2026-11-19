## **Module 1: Spring Framework fundamentals**

Must master

This is probably the most important module because practically everything in Spring Boot builds on it.

| Topic                  | What you should understand                                  |
| ---------------------- | ----------------------------------------------------------- |
| Spring Framework       | What problem does Spring solve?                             |
| IoC                    | Inversion of Control                                        |
| DI                     | Dependency Injection and how it works                       |
| Beans                  | What is a Spring Bean?                                      |
| ApplicationContext     | What does it manage?                                        |
| Bean lifecycle         | How a bean is created, initialized and destroyed            |
| Component Scanning     | How Spring discovers classes                                |
| Constructor Injection  | Why it is generally preferred                               |
| Bean Scopes            | Singleton, Prototype, Request, Session                      |
| Stereotype annotations | `@Component`, `@Service`, `@Repository`, `@Controller`      |
| Configuration          | `@Configuration`, `@Bean`                                   |
| AOP                    | What is aspect-oriented programming and where is it useful? |

**You must be able to answer these questions:**

1. What is the difference between Spring and Spring Boot?
2. What is IoC? How does DI implement it?
3. What happens when you annotate a class with `@Component`?
4. What is the difference between `@Component`, `@Service` and `@Repository`?
5. What is a Spring Bean?
6. How does Spring create and manage beans?
7. Why is constructor injection preferred over field injection?
8. What is the difference between `@Bean` and `@Component`?
9. What happens when two beans of the same type exist?
10. What is the difference between singleton and prototype scope?

You should also understand AOP at a conceptual level, including proxies and common applications such as transactions.

Official reference: [Spring IoC Container and Beans](https://docs.spring.io/spring-framework/reference/6.2/core/beans/introduction.html?utm_source=chatgpt.com).

## **Module 2: Spring Boot fundamentals**

Must master

| Topic                      | What to understand                              |
| -------------------------- | ----------------------------------------------- |
| Spring Boot                | Why it exists                                   |
| `@SpringBootApplication`   | What it combines internally                     |
| Auto-configuration         | How Spring Boot configures things automatically |
| Starters                   | Why we use starter dependencies                 |
| Embedded servers           | Tomcat and application startup                  |
| `application.properties`   | External configuration                          |
| YAML                       | Alternative configuration format                |
| Profiles                   | Dev, test and production configurations         |
| Maven                      | Dependencies, lifecycle, packaging              |
| `@ConfigurationProperties` | Type-safe configuration                         |

The most important concept here is auto-configuration.

For example:

When you add a Spring Web dependency, Spring Boot can automatically configure the web application infrastructure based on the libraries present on the classpath.

But what if you define your own configuration?

What if a required dependency is missing?

What if two configurations conflict?

These are the types of follow-up questions you should understand.

Also understand:

- `@SpringBootApplication` = `@SpringBootConfiguration` + `@EnableAutoConfiguration` + `@ComponentScan`.
- How `java -jar` starts an executable Spring Boot application.
- Why Spring Boot applications can run without deploying WAR files to an externally managed Tomcat server.

Official references: [Auto-configuration](https://docs.spring.io/spring-boot/reference/using/auto-configuration.html?utm_source=chatgpt.com) and [Starters and dependency management](https://docs.spring.io/spring-boot/reference/using/build-systems.html?utm_source=chatgpt.com).

## **Module 3: REST APIs using Spring MVC**

Must master — hands-on

This is where you should start writing code.

| Topic               | What to understand           |
| ------------------- | ---------------------------- |
| `@RestController`   | REST controller              |
| `@RequestMapping`   | Mapping requests             |
| `@GetMapping`       | GET endpoint                 |
| `@PostMapping`      | POST endpoint                |
| `@PutMapping`       | PUT endpoint                 |
| `@PatchMapping`     | PATCH endpoint               |
| `@DeleteMapping`    | DELETE endpoint              |
| `@PathVariable`     | Extracting URL parameters    |
| `@RequestParam`     | Extracting query parameters  |
| `@RequestBody`      | Reading request bodies       |
| `ResponseEntity`    | Controlling HTTP responses   |
| DTO                 | Data Transfer Object         |
| `@Valid`            | Validating input             |
| `@ControllerAdvice` | Global exception handling    |
| `@ExceptionHandler` | Handling specific exceptions |

You must understand this complete execution flow:

**Client**

Sends HTTP request

**DispatcherServlet**

Receives and dispatches the request

**Controller**

Handles HTTP request

**Service**

Business logic

**Repository**

Database operations

**Database**

Stores or retrieves data

Response travels back through the application to the client.

You should be able to explain what happens at every layer.

Also practise writing APIs that handle:

- Invalid input.
- Resource not found.
- Duplicate records.
- Unexpected server errors.
- Proper HTTP status codes.

Official references: [Spring MVC request mapping](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller/ann-requestmapping.html?utm_source=chatgpt.com) and [Spring MVC validation](https://docs.spring.io/spring-framework/reference/6.2/web/webmvc/mvc-controller/ann-validation.html?utm_source=chatgpt.com).

## **Module 4: Spring Data JPA and Hibernate**

Must master — hands-on

This is another area where interviewers frequently ask conceptual questions.

| Topic             | What to understand                |
| ----------------- | --------------------------------- |
| JPA               | Java Persistence API              |
| Hibernate         | JPA implementation                |
| Spring Data JPA   | Simplifies repository development |
| `@Entity`         | Maps Java class to database table |
| `@Id`             | Primary key                       |
| `@GeneratedValue` | ID generation                     |
| `JpaRepository`   | Repository functionality          |
| `@Query`          | Custom queries                    |
| JPQL              | Querying entities                 |
| Native SQL        | Querying database tables          |
| `@OneToOne`       | One-to-one relationship           |
| `@OneToMany`      | One-to-many relationship          |
| `@ManyToOne`      | Many-to-one relationship          |
| `@ManyToMany`     | Many-to-many relationship         |
| Lazy vs Eager     | Loading related entities          |
| Cascading         | Propagating entity operations     |
| Pagination        | Fetching records in pages         |
| N+1 problem       | Why unnecessary queries happen    |

**Particularly important interview questions:**

- Difference between JPA, Hibernate and Spring Data JPA.
- Difference between `findById()` and `getReferenceById()`.
- What is the persistence context?
- What is lazy loading?
- What is the N+1 query problem?
- How do you solve N+1?
- Difference between `CascadeType.REMOVE` and `orphanRemoval`.
- What is the owning side of a relationship?
- What happens when you save an entity?
- Why should we use DTOs instead of returning entities directly?

Do not just memorize relationship annotations. Understand how tables and foreign keys relate to one another.

Official references: [Spring Data JPA query methods](https://docs.spring.io/spring-data/jpa/reference/jpa/query-methods.html?utm_source=chatgpt.com).

## **Module 5: Transactions and database fundamentals**

Must master

| Topic                   | What to understand                                              |
| ----------------------- | --------------------------------------------------------------- |
| ACID                    | Transaction properties                                          |
| `@Transactional`        | How Spring manages transactions                                 |
| Transaction propagation | REQUIRED, REQUIRES_NEW, etc.                                    |
| Isolation levels        | READ_UNCOMMITTED, READ_COMMITTED, REPEATABLE_READ, SERIALIZABLE |
| Rollback                | When transactions roll back                                     |
| Dirty Read              | Reading uncommitted data                                        |
| Non-repeatable Read     | Different values in repeated reads                              |
| Phantom Read            | New rows appearing in repeated queries                          |
| Optimistic Locking      | Version-based conflict detection                                |
| Pessimistic Locking     | Locking database records                                        |

Pay special attention to:

1. What happens when an exception occurs inside a transaction?
2. Why does `@Transactional` sometimes appear not to work?
3. What happens if a method calls another transactional method within the same class?
4. Difference between REQUIRED and REQUIRES_NEW.
5. What is the difference between optimistic and pessimistic locking?

One important detail: Spring's default transactional behavior rolls back on unchecked exceptions and errors, but not generally on checked exceptions. Also, Spring's usual proxy-based transaction handling has a self-invocation limitation.

Official reference: [Using @Transactional](https://docs.spring.io/spring-framework/reference/data-access/transaction/declarative/annotations.html?utm_source=chatgpt.com).

## **Module 6: Spring Security**

Important

Don't attempt to become a security expert. Understand the standard authentication flow.

| Topic                           | Priority   |
| ------------------------------- | ---------- |
| Authentication vs Authorization | Must       |
| Spring Security architecture    | Must       |
| Security Filter Chain           | Must       |
| Password hashing                | Must       |
| BCrypt                          | Must       |
| JWT                             | Must       |
| Access token flow               | Must       |
| Stateless authentication        | Must       |
| Roles and authorities           | Must       |
| 401 vs 403                      | Must       |
| CORS                            | Basic      |
| CSRF                            | Basic      |
| OAuth2                          | Conceptual |

For JWT, understand this complete flow:

1. User sends username and password.
2. Application authenticates the user.
3. Application generates a signed JWT.
4. Client stores and sends the token in subsequent requests.
5. Security filters validate the token.
6. Application establishes the authenticated security context.
7. Authorization checks whether the user can access the requested resource.

You should be able to explain how this works without relying on a tutorial.

## **Module 7: Microservices architecture**

Must understand conceptually

This is where I don't want you wasting time trying to implement 10 different services.

First understand the architectural concepts.

| Topic                       | What you should understand                    |
| --------------------------- | --------------------------------------------- |
| Monolith vs Microservices   | Differences and trade-offs                    |
| Service decomposition       | How to split services                         |
| API Gateway                 | Single entry point                            |
| Service Discovery           | How services find each other                  |
| Load Balancing              | Distributing requests                         |
| Inter-service communication | REST vs messaging                             |
| Synchronous communication   | Request-response                              |
| Asynchronous communication  | Events and messages                           |
| Centralized configuration   | Managing service configuration                |
| Fault tolerance             | Handling failures                             |
| Circuit Breaker             | Preventing repeated calls to failing services |
| Retry                       | Retrying failed operations safely             |
| Timeout                     | Preventing indefinite waits                   |
| Bulkhead                    | Isolating resource failures                   |
| Distributed transactions    | Transactions across services                  |
| Saga Pattern                | Coordinating distributed business operations  |
| Eventual Consistency        | Temporary differences across services         |
| Idempotency                 | Safe handling of repeated requests            |
| Database per service        | Data ownership                                |

I would particularly focus on these scenarios:

**Scenario 1:** Payment service is down. What happens when Order Service calls it?

**Scenario 2:** Order Service sends the same payment request twice. How do you prevent duplicate payment?

**Scenario 3:** Inventory Service successfully reserves stock, but Payment Service fails. How do you handle the inconsistency?

**Scenario 4:** One service receives 10,000 requests. How do you distribute traffic?

These questions test whether you understand microservices rather than merely knowing their names.

For implementation-level understanding, know the basics of Spring Cloud, service discovery and Resilience4j. You do not need to build a full Eureka infrastructure immediately.

References: [Spring Cloud common abstractions](https://docs.spring.io/spring-cloud-commons/reference/spring-cloud-commons/common-abstractions.html?utm_source=chatgpt.com) and [Spring Cloud Circuit Breaker](https://docs.spring.io/spring-cloud-commons/reference/spring-cloud-circuitbreaker.html?utm_source=chatgpt.com).

## **Module 8: Testing and production fundamentals**

Important

| Topic                 | What to understand                 |
| --------------------- | ---------------------------------- |
| JUnit 5               | Writing tests                      |
| Mockito               | Mocking dependencies               |
| `@Mock`               | Creating mock objects              |
| `@InjectMocks`        | Injecting mocked dependencies      |
| `@WebMvcTest`         | Controller-layer tests             |
| `@DataJpaTest`        | Repository-layer tests             |
| `@SpringBootTest`     | Application integration tests      |
| MockMvc               | Testing MVC requests               |
| Profiles              | Environment-specific configuration |
| Logging               | SLF4J and Logback basics           |
| Actuator              | Health and monitoring              |
| Docker                | Containerizing an application      |
| Environment variables | External configuration             |
| Basic CI/CD           | Build, test and deployment flow    |

You should know the difference between unit testing and integration testing.

Also understand why we should not expose sensitive Actuator endpoints publicly.

References: [Spring Boot testing](https://docs.spring.io/spring-boot/3.5/reference/testing/spring-boot-applications.html?utm_source=chatgpt.com) and [Spring Boot Actuator](https://docs.spring.io/spring-boot/3.5/reference/actuator/endpoints.html?utm_source=chatgpt.com).
