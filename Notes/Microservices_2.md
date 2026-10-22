WebServices:
system designed to support interoperable machine to machine interactions over network

server ---> <---- consumer 
message exchange format: SOAP web services XML, REST web services JSON


Request handling:
DispatcherServlet - Front controller
Bean to JSON - JacksonHttpMessageConverter
Error Config 
All handled by AutoConfiguration



@Component
UserService

@ControllerAdvice common responseentityexception class


GetAllUsers
GetOneUserById @PathVariable
200
Throw exception if user is not available

PostOneUser @RequestBody
201 created
Throw exception if validation failed 400 Bad request
Validation @Valid
 1) @Size
 2) @Past for date

DeleterOneUserById
200 
Throw exception if user is not available

Advance REST API Features:
Documentation: Resources, actions, req/res structure
springdoc-openapi
