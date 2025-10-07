# DriverService

This is a minimal Spring Boot application extracted to host only the `DriverController` from the `rideshare-api` project.

Features:
- Spring Boot 3.1.4
- Java 17
- Maven build
- Spring Boot Actuator (health, metrics, info)
- Minimal stub implementations of services so the app can start for local testing

Location:
DriverService project lives at `/Users/Hershey/Documents/Sathiyan/App_Workspace/DriverService`

Requirements
- Java 17
- Maven

Build & Run
1. Build

```bash
cd /Users/Hershey/Documents/Sathiyan/App_Workspace/DriverService
mvn -DskipTests package
```

2. Run

```bash
# run via maven
mvn spring-boot:run

# or run the jar
java -jar target/DriverService.jar
```

3. Health endpoint (Actuator)

```
GET http://localhost:8082/drivers/actuator/health
```

Notes
- The project contains only minimal DTOs, entities and service stubs. Replace the stubs in `service.impl` with real implementations from the main `rideshare-api` project as needed.
- Application properties are in `src/main/resources/application.properties`.
