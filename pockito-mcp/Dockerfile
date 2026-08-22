# Built from the repository root so the shared modules are in the build context:
#   docker build -f pockito-mcp/Dockerfile -t ghassenbrg/pockito-mcp:1.0.0 .

FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /build

# Poms first: dependency resolution is the slow layer, and it only needs to be
# redone when a pom actually changes.
COPY pom.xml ./
COPY shared/pockito-contracts/pom.xml shared/pockito-contracts/
COPY shared/pockito-web-support/pom.xml shared/pockito-web-support/
COPY shared/pockito-core-client/pom.xml shared/pockito-core-client/
COPY pockito-core/pom.xml pockito-core/
COPY pockito-api/pom.xml pockito-api/
COPY pockito-mcp/pom.xml pockito-mcp/
COPY pockito-notification-worker/pom.xml pockito-notification-worker/
RUN mvn -B -q dependency:go-offline -DskipTests || true

COPY shared shared
COPY pockito-core pockito-core
COPY pockito-api pockito-api
COPY pockito-mcp pockito-mcp
COPY pockito-notification-worker pockito-notification-worker
RUN mvn -B -pl pockito-mcp -am package -DskipTests

FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# Never run as root: a container escape should not start with uid 0.
RUN addgroup -S pockito && adduser -S -G pockito pockito
COPY --from=build --chown=pockito:pockito /build/pockito-mcp/target/*.jar app.jar
USER pockito

ENV TZ=Asia/Tokyo \
    JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=70 -XX:+UseG1GC -XX:+ExitOnOutOfMemoryError"

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
