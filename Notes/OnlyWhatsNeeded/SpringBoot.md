# Spring Boot + Microservices: Interview Roadmap (AI-Driven)

Built for: backend / SDE-1 interviews, Java 17+, Spring Boot 3.x.
Method: learn only from AI, using open-ended "dump everything" prompts, one chat per module.

> Honest scope note: no roadmap can guarantee an interviewer won't ask something outside it. This one targets the topics that come up most often in Spring Boot + microservices rounds, and it deliberately skips what is rarely asked.

---

## 0. How to avoid resource hell (read once)

1. **One AI, one chat per module.** Don't cross-check with blogs or videos until you finish the module's depth check.
2. **Paste the Master Primer (below) first** in every new chat. It forces the AI to use official terminology and list the synonyms, which solves the "same thing, different name" problem.
3. **When two terms feel different, don't research. Use the Reconciliation Prompt.**
4. **Done = you pass the Depth Check.** Answer each question out loud in about 2 minutes. If you can't, re-prompt on that gap only. Don't re-read everything.
5. **Keep a personal glossary file.** One line per term: `official term = other names = one-line meaning`.

### Master Primer (paste at the start of every chat)

```
I'm preparing for backend (SDE-1) interviews at product-based companies.
Stack: Java 17+, Spring Boot 3.x. All code must be in Java.

For every topic I give you:
1. Use the official Spring/Java terminology. Next to each term, list in
   brackets the other names commonly used for the same thing.
2. Cover: what problem it solves, how it works internally, failure modes,
   trade-offs, and when NOT to use it.
3. Include Java code wherever it clarifies behavior.
4. End with the interview questions usually asked on this topic, each with
   a strong model answer and the follow-up "trap" questions.
5. Do not teach REST/HTTP basics, Java syntax, or "hello world" setup.
6. Be exhaustive on the topic. Don't ask me clarifying questions.
   Don't stop early; if the answer is long, continue until complete.
```

### Reconciliation Prompt (use whenever terms clash)

```
I've seen "<term A>" and "<term B>" used across different sources. Tell me
whether they refer to the same thing, a subset/superset, or different things.
Give the one official term I should use in interviews, and a mapping table of
all the aliases. Then give a 3-line answer I can say out loud.
```

### Grill-Me Prompt (use at the end of each module)

```
Act as a strict senior interviewer. Topic: <module name>. Ask me one question
at a time, starting medium difficulty and increasing. After each of my answers,
tell me what was wrong or missing, what a strong answer includes, then ask a
deeper follow-up on the weakest part. Do 10 rounds, then give me a list of my
weak spots.
```

---

## 1. Skip list (don't spend time here)

| Skip | Why |
|---|---|
| REST basics (verbs, status codes, Postman) | You already work with REST APIs. Only the internals in A4 matter. |
| Spring XML config, JSP/Thymeleaf, SOAP | Rarely asked now |
| Spring Batch, Spring Integration, GraphQL | Niche, so only if the JD asks |
| WebFlux deep dive | Know the gist only (A7) |
| Building Eureka/Zuul/Hystrix projects | Deprecated. Know the concepts only (B3, B4) |
| Maven/Gradle internals | Almost never asked |

---

## 2. Priority legend and suggested order

- **[P0]** Asked in most interviews. Must master.
- **[P1]** Asked often. Know well.
- **[P2]** Occasionally asked. Know the gist.

Suggested order (adjust to your available time): **A1 → A2 → A3 → A5 → A4 → B1 → B2 → B4 → B5 → B9 → A6 → B7 → B3 → B6 → B8 → A7 → A8 → B10 (capstone)**

---

# PART A: Spring and Spring Boot

## A1. IoC, DI, Bean Lifecycle [P0]

**Prompts**
```
Everything about the Spring IoC container: BeanFactory vs ApplicationContext,
and the complete journey of a bean from class to ready-to-use object
(BeanDefinition -> instantiation -> property population -> Aware callbacks ->
BeanPostProcessors -> init -> ready -> destroy). Show where each extension
point (BeanFactoryPostProcessor, BeanPostProcessor, @PostConstruct,
InitializingBean) fits and what each is used for in real frameworks.
```
```
Dependency injection in full depth: constructor vs setter vs field injection
and why constructor injection is recommended, how @Autowired resolves
candidates (type -> @Primary/@Qualifier -> name), optional and collection
injection, and circular dependencies: how Spring's three-level cache resolves
them, why Boot 2.6+ prohibits them by default, and how to fix the design.
```
```
@Component vs @Bean vs @Configuration, stereotype annotations, component
scanning, and @Configuration full mode vs lite mode (proxyBeanMethods).
Also: bean scopes, the singleton-with-prototype-dependency problem and its
fixes, and thread-safety of singleton beans.
```

**Depth check**
- Walk through the bean lifecycle with the extension points.
- How does Spring resolve a circular dependency, and when does it fail?
- Why is constructor injection preferred?
- Singleton bean needs a fresh prototype per call. What do you do?
- What does `proxyBeanMethods = false` change?

## A2. AOP and Proxies [P0]

**Prompts**
```
Everything about Spring AOP: how proxies are created (JDK dynamic proxy vs
CGLIB, how Boot chooses), advice types, pointcut expression syntax, and
ordering of multiple aspects. Explain how @Transactional, @Async, @Cacheable
and @Retryable work internally through proxies, and the self-invocation
pitfall (why calling a @Transactional method from the same class does
nothing) with all the ways to fix it. Also cover Spring AOP vs AspectJ.
```

**Depth check**
- Why does `this.method()` bypass @Transactional?
- JDK proxy vs CGLIB: what are the constraints (final classes, interfaces)?
- Write an aspect that logs execution time.

## A3. Spring Boot Internals [P0]

**Prompts**
```
Spring Boot internals end to end: what @SpringBootApplication is composed of,
what SpringApplication.run() does step by step (environment, context creation,
refresh, runners, embedded server startup), and how auto-configuration works
(AutoConfiguration.imports in Boot 3 vs spring.factories earlier, @Conditional*
annotations, ordering, how to debug with the conditions report and how to
exclude). Also how to write a custom starter.
```
```
Externalized configuration in Spring Boot: property source precedence order,
profiles, @Value vs @ConfigurationProperties (relaxed binding, validation,
records), config import, secrets handling, and Actuator (key endpoints,
health groups, liveness/readiness, custom health indicators, securing
endpoints, Micrometer metrics).
```

**Depth check**
- How does Boot know to configure a DataSource without you doing anything?
- How do you override an auto-configured bean?
- Order of property sources: env var vs application.yml vs command line?
- How do you build a custom starter?

## A4. Web Layer Internals (not REST basics) [P1]

**Prompts**
```
Spring MVC internals: the full request lifecycle through DispatcherServlet
(HandlerMapping, HandlerAdapter, argument resolvers, HttpMessageConverters,
return value handlers, view/exception resolvers), the thread-per-request
model in embedded Tomcat, and Filter vs HandlerInterceptor vs AOP: what each
sees and when to use which.
```
```
Production-grade request handling in Spring Boot: global exception handling
(@ControllerAdvice, ProblemDetail/RFC 7807), Bean Validation (groups, custom
validators, validating path/query params), request/response DTO mapping,
pagination, file upload/streaming, CORS, and common pitfalls interviewers ask
about (e.g., 400 vs 500 handling, validation not firing).
```

**Depth check**
- Trace a request from Tomcat to your controller method and back.
- Filter vs interceptor: which runs first, and which can see the handler?
- How do you return a consistent error body for all exceptions?

## A5. Data Access and Transactions [P0]

**Prompts**
```
@Transactional in complete depth: propagation levels (with realistic examples
of REQUIRED vs REQUIRES_NEW vs NESTED etc.), isolation levels and the anomalies
each prevents, rollback rules (checked vs unchecked, rollbackFor), readOnly,
timeouts, and every common pitfall (self-invocation, private methods,
swallowed exceptions, transaction on wrong layer, async boundaries).
```
```
JPA/Hibernate as asked in interviews: entity lifecycle states, persistence
context and first-level cache, dirty checking, lazy vs eager loading and
LazyInitializationException fixes, the N+1 problem with every solution
(fetch join, entity graph, batch size), optimistic vs pessimistic locking
(@Version), open-in-view tradeoffs, cascade types, equals/hashCode on
entities, and DTO projections.
```
```
Spring Data JPA specifics and connection management: repository hierarchy,
derived queries vs @Query vs Specifications, pagination and sorting,
HikariCP connection pool (what the settings mean and how to size it),
and how to diagnose slow queries and connection pool exhaustion in production.
```

**Depth check**
- A REQUIRES_NEW method throws. What happens to the outer transaction?
- Why did the rollback not happen when I caught the exception?
- Explain and fix N+1 on a `@OneToMany`.
- Two users update the same row. How do you prevent lost updates?
- Connection pool is exhausted in production. What are the likely causes?

## A6. Spring Security [P1]

**Prompts**
```
Spring Security architecture as asked in interviews: SecurityFilterChain and
the filter order, the authentication flow (AuthenticationManager,
ProviderManager, AuthenticationProvider, UserDetailsService, PasswordEncoder,
SecurityContextHolder), authorization (URL-based vs method security with
@PreAuthorize), CSRF and CORS and when to disable them, and how to write a
custom filter. Use Spring Security 6 style configuration (lambda DSL).
```
```
Stateless authentication in Spring Boot: JWT structure and validation,
access vs refresh token design, token revocation problem and solutions,
OAuth2 and OIDC flows (authorization code + PKCE, client credentials), Spring
Boot as OAuth2 resource server, and the typical security mistakes interviewers
probe (storing JWT, long-lived tokens, algorithm confusion).
```

**Depth check**
- Walk through what happens when a request hits a secured endpoint.
- JWT vs session: tradeoffs? How do you revoke a JWT?
- Which OAuth2 flow for service-to-service calls, and why?

## A7. Concurrency, Async, Caching, Performance [P1]

**Prompts**
```
Concurrency in Spring Boot applications: how Tomcat thread pool and request
handling work, @Async and TaskExecutor configuration (and the pitfalls),
@Scheduled and running it safely on multiple instances, virtual threads in
Boot 3.2+ (what changes, what doesn't, pinning), and MVC vs WebFlux at the
level of "when would you choose which and why". Keep WebFlux to concepts only.
```
```
Caching in Spring: @Cacheable/@CachePut/@CacheEvict internals (proxy-based),
cache providers (Caffeine vs Redis), cache-aside vs read-through vs
write-through/back, TTL and eviction, cache stampede, consistency problems,
and how to cache safely in a multi-instance deployment.
```

**Depth check**
- Why might @Async silently run synchronously?
- Same @Scheduled job on 3 instances. Problem and fix?
- Cache stampede: what is it, how do you prevent it?

## A8. Testing [P2]

**Prompts**
```
Testing Spring Boot applications the way a senior reviewer expects: test
slices (@WebMvcTest, @DataJpaTest, @SpringBootTest and when each), MockMvc,
Mockito (@Mock vs @MockBean vs @SpyBean), Testcontainers for DB/Kafka,
test profiles, and contract testing (Pact / Spring Cloud Contract) in a
microservices setup. Include the test pyramid for microservices.
```

**Depth check**
- When do you use @WebMvcTest vs @SpringBootTest?
- How do you test a service that calls another service?

---

# PART B: Microservices

## B1. Foundations and Decomposition [P0]

**Prompts**
```
Microservices architecture fundamentals for interviews: monolith vs modular
monolith vs microservices tradeoffs (including when microservices are the
WRONG choice), service boundaries using Domain-Driven Design (bounded context,
aggregate), database-per-service and its consequences, shared-database
anti-pattern, strangler fig pattern for migrating a monolith, 12-factor app
principles, and the distributed-system problems microservices introduce
(network failure, latency, partial failure, data consistency).
```

**Depth check**
- How do you decide where one service ends and another begins?
- Monolith to microservices: how would you migrate safely?
- Name 5 problems microservices introduce that a monolith doesn't.

## B2. Inter-Service Communication [P0]

**Prompts**
```
Service-to-service communication: synchronous (REST via RestClient/WebClient/
OpenFeign, gRPC) vs asynchronous (message broker/events). Cover timeouts,
retries, idempotency (idempotency keys and how to implement them), API
versioning and backward compatibility, request/response vs event-driven vs
event-carried state transfer, and how to choose between sync and async for a
given use case. Include the failure modes of each, such as cascading failure
and the distributed monolith problem.
```

**Depth check**
- Order service calls Payment service synchronously. What can go wrong?
- How do you make a POST endpoint idempotent?
- How do you change an API without breaking consumers?

## B3. Infrastructure Patterns [P1]

**Prompts**
```
Microservice infrastructure patterns: API Gateway (responsibilities, Spring
Cloud Gateway, what NOT to put in it), BFF pattern, service discovery
(client-side vs server-side, Eureka concept vs Kubernetes DNS/Services),
client-side load balancing, centralized configuration (Spring Cloud Config
vs Kubernetes ConfigMaps/Secrets), and which of these are obsolete or
redundant when running on Kubernetes.
```

**Depth check**
- Why do you need an API gateway? What's the risk?
- How does service discovery work, and does Kubernetes make Eureka unnecessary?

## B4. Resilience [P0]

**Prompts**
```
Resilience patterns for microservices using Resilience4j with Spring Boot:
circuit breaker (states, sliding window, thresholds), retry with exponential
backoff and jitter, timeout, bulkhead, rate limiter, fallback. Explain the
failure each pattern prevents, how they combine and the correct ordering,
retry storms and amplification, and how to test these patterns. Include
config examples and the metrics to monitor.
```

**Depth check**
- Explain circuit breaker states and when each transition happens.
- Why can retries make an outage worse?
- Circuit breaker vs bulkhead: what's the difference?

## B5. Distributed Data and Consistency [P0]

**Prompts**
```
Data consistency across microservices: why distributed transactions (2PC) are
avoided, CAP theorem and eventual consistency in practical terms, the Saga
pattern (choreography vs orchestration with a full order-payment-inventory
example including compensating transactions), the Transactional Outbox
pattern (and CDC with Debezium), the dual-write problem, idempotent consumers,
CQRS and when it's justified, and event sourcing basics.
```

**Depth check**
- Place order, deduct inventory, charge payment: design it with a saga, and explain compensation if payment fails.
- What is the dual-write problem and how does outbox solve it?
- Choreography vs orchestration: tradeoffs?

## B6. Observability [P1]

**Prompts**
```
Observability in microservices: the three pillars (logs, metrics, traces),
distributed tracing with Micrometer Tracing/OpenTelemetry (trace ID, span ID,
context propagation across HTTP and Kafka), structured logging with
correlation IDs, Prometheus + Grafana metrics (RED and USE methods), alerting
on symptoms vs causes, and how I would debug a slow request across five
services in production step by step.
```

**Depth check**
- A user reports a slow checkout. How do you find the bottleneck?
- How does a trace ID travel across services?

## B7. Security Across Services [P1]

**Prompts**
```
Security in a microservices system: authentication at the gateway vs in each
service, token propagation and token exchange, service-to-service auth (mTLS,
client credentials), zero-trust principle, secrets management (Vault,
Kubernetes Secrets), and rate limiting / abuse protection at the edge.
```

**Depth check**
- Where do you validate the JWT: gateway only, or in each service?
- How does service A prove its identity to service B?

## B8. Deployment and Operations [P1]

**Prompts**
```
Deploying Spring Boot microservices: Dockerfile best practices (layered jars,
JVM container memory settings), Kubernetes essentials for backend developers
(Pod, Deployment, Service, Ingress, ConfigMap, Secret, HPA, liveness vs
readiness vs startup probes mapped to Spring Boot Actuator), graceful
shutdown, rolling vs blue-green vs canary deployments, database migration
strategy with Flyway/Liquibase and backward-compatible schema changes,
and a typical CI/CD pipeline.
```

**Depth check**
- Liveness vs readiness: what happens if you get them wrong?
- How do you deploy a breaking DB schema change without downtime?

## B9. Messaging and Kafka Essentials [P1]

**Prompts**
```
Kafka for backend interviews: topics, partitions, offsets, consumer groups,
ordering guarantees (and how partition key choice affects them), delivery
semantics (at-most/at-least/exactly-once and what exactly-once really means),
producer acks and idempotent producer, consumer offset commit strategies,
rebalancing, dead-letter topics and retry topics, handling poison messages,
consumer lag, and Spring Kafka specifics. Also Kafka vs RabbitMQ: when to
choose which.
```

**Depth check**
- How do you guarantee ordering for one customer's events?
- Consumer crashes after processing but before commit. What happens?
- How do you handle a poison message?

## B10. Capstone: Design Scenarios [P0]

Run each with the Grill-Me style: first ask the AI to design it, then challenge it.

```
Design an <order management / ride booking / payments / notification>
system as microservices. Give: service breakdown and boundaries, database
per service, sync vs async communication choices with reasons, the saga for
the main flow, resilience configuration, idempotency strategy, security,
observability, and deployment. Then list the 10 hardest follow-up questions
an interviewer would ask about this design, with strong answers.
```
```
Take the design above and break it: what happens if each service goes down,
the broker is down, a message is duplicated, messages arrive out of order,
the DB fails over mid-transaction, or traffic spikes 10x? For each, give the
failure behavior and the fix.
```

---

## 3. Final week: mock rounds

1. Run the **Grill-Me Prompt** across all P0 modules (A1, A2, A3, A5, B1, B2, B4, B5, B10).
2. Ask the AI: `"Based on my answers so far, list my 10 weakest topics, ranked, with a one-page cheat sheet for each."`
3. Practice explaining each depth-check answer out loud in about 2 minutes.
4. Prepare a 3-minute walkthrough of your own project's architecture, including what you would improve (it ties the roadmap to your real experience).

## 4. Tip for AI answers going stale

Spring Boot 3.x / Spring Security 6 changed several APIs. If a code sample uses `WebSecurityConfigurerAdapter`, `spring.factories` for auto-config, or `javax.*` imports, ask: `"Rewrite this for Spring Boot 3.x (jakarta.*, SecurityFilterChain bean)."`
