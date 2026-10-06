# Spring Boot: SDE-1 Interview Roadmap

Rule of thumb: SDE-1 interviews test **"why/how does it work"** on the core, not breadth.
Priority: **P0 = asked almost every time**, **P1 = asked often**, **P2 = skim only if time remains**.

## P0: Must Know

### 1. Spring Boot Fundamentals
- Spring vs Spring Boot (what Boot removes: XML config, manual setup)
- Starters and what they do (`spring-boot-starter-web`, `-data-jpa`)
- `@SpringBootApplication` = `@Configuration` + `@EnableAutoConfiguration` + `@ComponentScan`
- **Auto-configuration: how it works** (classpath scanning + `@ConditionalOnClass` / `@ConditionalOnMissingBean` / `@ConditionalOnProperty`)
- Embedded Tomcat, executable jar

### 2. IoC and Dependency Injection
- IoC vs DI; `ApplicationContext` vs `BeanFactory`
- Constructor vs setter vs field injection (**why constructor injection is preferred**)
- `@Component`, `@Service`, `@Repository`, `@Controller`, `@RestController`
- `@Autowired`, `@Qualifier`, `@Primary` (two beans of same type: how to resolve)
- `@Configuration` + `@Bean` vs `@Component`
- Bean scopes: singleton (default), prototype, request, session
- Bean lifecycle: instantiate -> populate -> `@PostConstruct` -> ready -> `@PreDestroy`
- Circular dependency: what it is, how to fix

### 3. Configuration
- `application.properties` vs `application.yml`
- Profiles (`@Profile`, `application-dev.yml`)
- `@Value` vs `@ConfigurationProperties`

### 4. REST and Web MVC
- HTTP methods; **PUT vs PATCH**, idempotency (GET/PUT/DELETE idempotent, POST not)
- Status codes: 200, 201, 204, 400, 401, 403, 404, 409, 500
- Controller -> Service -> Repository -> DTO layering (and why DTOs, not entities)
- `@RequestMapping`, `@GetMapping`/`@PostMapping`..., `@PathVariable`, `@RequestParam`, `@RequestBody`, `ResponseEntity`
- `@RestController` vs `@Controller`
- **Request flow:** Client -> DispatcherServlet -> HandlerMapping -> Controller -> response
- Global exception handling: `@ControllerAdvice` + `@ExceptionHandler`
- Validation: `@Valid`, `@NotNull`, `@NotBlank`, `@Size`, `@Email`
- Filter vs Interceptor (servlet level vs Spring MVC level)

### 5. Spring Data JPA
- `JpaRepository`, CRUD, derived query methods (`findByEmailAndStatus`)
- `@Query` (JPQL, native)
- Pagination and sorting (`Pageable`, `Page`)
- Entity basics: `@Entity`, `@Id`, `@GeneratedValue`, `@Column`, `@Table`
- **Relationships:** `@OneToMany`, `@ManyToOne`, `@ManyToMany`, `mappedBy`, owning side
- **Lazy vs Eager** loading, `LazyInitializationException`
- **N+1 problem**: what it is, fix with `JOIN FETCH` / `@EntityGraph`
- Cascade types, `orphanRemoval`

### 6. Transactions
- ACID
- `@Transactional`: implemented via **proxy**
- **Propagation:** `REQUIRED` (default), `REQUIRES_NEW` (know the difference)
- Rollback: by default only **unchecked** exceptions (`rollbackFor` for checked)
- **Pitfall:** self-invocation (calling a `@Transactional` method from within the same class bypasses the proxy)
- Isolation levels and the problems they prevent (dirty read, non-repeatable read, phantom read)

### 7. Spring Security (basics)
- Filter chain concept, `SecurityContext`
- Authentication vs Authorization
- `UserDetailsService`, `PasswordEncoder` (BCrypt: why hash, not encrypt)
- **JWT flow:** login -> token issued -> client sends `Authorization: Bearer` -> filter validates -> sets `SecurityContext`
- Stateless vs session-based auth
- Roles vs authorities, `@PreAuthorize`
- `SecurityFilterChain` bean (current style; `WebSecurityConfigurerAdapter` is removed)

### 8. Testing (SDE-1 level)
- JUnit 5 + Mockito (`@Mock`, `@InjectMocks`, `when().thenReturn()`)
- `@SpringBootTest` vs `@WebMvcTest` vs `@DataJpaTest` (full context vs slice)
- `MockMvc`, `@MockBean`


## P1: Asked Often

### 9. AOP (concept level)
- What it is and why (cross-cutting concerns: logging, auditing, transactions)
- Terms: Aspect, Advice, Pointcut, Join Point
- `@Before`, `@After`, `@Around`
- Proxies: JDK dynamic vs CGLIB (explains why `@Transactional` works the way it does)

### 10. Hibernate Essentials
- Entity states: transient, persistent, detached, removed
- First-level cache (session scoped) vs second-level cache (SessionFactory scoped)
- HQL/JPQL basics
- HikariCP is the default connection pool

### 11. Actuator
- `/actuator/health`, `/metrics`, `/info`
- Why you'd secure/limit exposed endpoints

### 12. Caching, Async, Scheduling
- `@EnableCaching`, `@Cacheable`, `@CacheEvict`
- `@Async` (needs `@EnableAsync`), `@Scheduled` (fixedRate vs cron)

### 13. Calling Other Services
- `RestTemplate` (legacy), `WebClient`, `RestClient` (Boot 3.2+): know they exist and which is current

### 14. Practical Bits
- Logging: SLF4J + Logback, log levels
- Maven basics, `pom.xml` dependency management
- H2 (dev/test) vs MySQL/PostgreSQL (prod) config
- Swagger/OpenAPI (springdoc) just to document APIs


## P2: Skim Only

- Embedded server tuning (Jetty/Undertow, thread pools)
- JDBC Template / RowMapper
- Criteria API, Specifications
- OAuth2 flows in depth
- File uploads (multipart)
- Docker, CI/CD
- Kafka/RabbitMQ, Redis, Spring Cloud, WebFlux, GraalVM


## Top Interview Questions Checklist

Be able to answer each in 2-3 sentences:

1. How does auto-configuration work?
2. What does `@SpringBootApplication` do?
3. IoC vs DI? Why constructor injection?
4. Bean scopes and lifecycle?
5. Two beans of the same type: how do you resolve it?
6. `@Component` vs `@Bean`? `@Controller` vs `@RestController`?
7. Walk through a request in Spring MVC (DispatcherServlet flow).
8. Filter vs Interceptor?
9. How do you handle exceptions globally?
10. PUT vs PATCH? Which HTTP methods are idempotent?
11. Lazy vs Eager loading? What is the N+1 problem and its fix?
12. `mappedBy`: what does it mean?
13. How does `@Transactional` work internally? When does it **not** work?
14. Propagation: `REQUIRED` vs `REQUIRES_NEW`?
15. Which exceptions trigger rollback by default?
16. How would you implement JWT authentication in Spring Boot?
17. `@Mock` vs `@MockBean`? `@WebMvcTest` vs `@SpringBootTest`?
18. `@Value` vs `@ConfigurationProperties`?
19. How do profiles work?
20. What is a circular dependency and how do you fix it?
