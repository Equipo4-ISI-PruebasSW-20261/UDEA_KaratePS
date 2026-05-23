FROM maven:3.9.16-eclipse-temurin-17

WORKDIR /workspace

COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

COPY src ./src

CMD ["mvn", "test", "-Dkarate.env=prod"]