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
