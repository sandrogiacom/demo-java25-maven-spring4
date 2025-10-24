# Read Me First
The following was discovered as part of building this project:

* The JVM level was changed from '25' to '24' as the Kotlin version does not support Java 25 yet.
* The original package name 'com.giacom.demo-java25' is invalid and this project uses 'com.giacom.demo_java25' instead.

# Getting Started

### Reference Documentation
For further reference, please consider the following sections:

* [Official Apache Maven documentation](https://maven.apache.org/guides/index.html)
* [Spring Boot Maven Plugin Reference Guide](https://docs.spring.io/spring-boot/4.0.0-SNAPSHOT/maven-plugin)
* [Create an OCI image](https://docs.spring.io/spring-boot/4.0.0-SNAPSHOT/maven-plugin/build-image.html)
* [Coroutines section of the Spring Framework Documentation](https://docs.spring.io/spring-framework/reference/7.0.0-SNAPSHOT/languages/kotlin/coroutines.html)
* [Spring Boot Testcontainers support](https://docs.spring.io/spring-boot/4.0.0-SNAPSHOT/reference/testing/testcontainers.html#testing.testcontainers)
* [Testcontainers Postgres Module Reference Guide](https://java.testcontainers.org/modules/databases/postgres/)
* [Spring Reactive Web](https://docs.spring.io/spring-boot/4.0.0-SNAPSHOT/reference/web/reactive.html)
* [Spring Data JPA](https://docs.spring.io/spring-boot/4.0.0-SNAPSHOT/reference/data/sql.html#data.sql.jpa-and-spring-data)
* [Validation](https://docs.spring.io/spring-boot/4.0.0-SNAPSHOT/reference/io/validation.html)
* [Spring Boot Actuator](https://docs.spring.io/spring-boot/4.0.0-SNAPSHOT/reference/actuator/index.html)
* [Testcontainers](https://java.testcontainers.org/)
* [OpenFeign](https://docs.spring.io/spring-cloud-openfeign/reference/)

### Guides
The following guides illustrate how to use some features concretely:

* [Building a Reactive RESTful Web Service](https://spring.io/guides/gs/reactive-rest-service/)
* [Accessing Data with JPA](https://spring.io/guides/gs/accessing-data-jpa/)
* [Validation](https://spring.io/guides/gs/validating-form-input/)
* [Building a RESTful Web Service with Spring Boot Actuator](https://spring.io/guides/gs/actuator-service/)

### Additional Links
These additional references should also help you:

* [Declarative REST calls with Spring Cloud OpenFeign sample](https://github.com/spring-cloud-samples/feign-eureka)

### Testcontainers support

This project uses [Testcontainers at development time](https://docs.spring.io/spring-boot/4.0.0-SNAPSHOT/reference/features/dev-services.html#features.dev-services.testcontainers).

Testcontainers has been configured to use the following Docker images:

* [`postgres:latest`](https://hub.docker.com/_/postgres)

Please review the tags of the used images and set them to the same as you're running in production.

### Maven Parent overrides

Due to Maven's design, elements are inherited from the parent POM to the project POM.
While most of the inheritance is fine, it also inherits unwanted elements like `<license>` and `<developers>` from the parent.
To prevent this, the project POM contains empty overrides for these elements.
If you manually switch to a different parent and actually want the inheritance, you need to remove those overrides.

