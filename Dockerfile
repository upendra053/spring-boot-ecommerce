# #Docker file for General Spring Boot Exercise
# #FROM openjdk:8
# FROM openjdk:17-jdk-slim
# RUN mkdir springapp
# WORKDIR /springapp
# #ADD target/GeneralProgExec-2.0.0-SNAPSHOT.jar GeneralProgExec-2.0.0-SNAPSHOT.jar
# ADD target/spring-boot-ecommerce-0.0.1-SNAPSHOT.jar spring-boot-ecommerce-0.0.1-SNAPSHOT.jar
# EXPOSE 8081
# ENTRYPOINT ["java", "-jar", "spring-boot-ecommerce-0.0.1-SNAPSHOT.jar"]

# Stage 1: Build the application using Maven and JDK 17
FROM maven:3.9.4-eclipse-temurin-17 AS build

# Set working directory inside the container
WORKDIR /spring-boot-ecommerce

# Copy Maven wrapper and pom.xml
COPY pom.xml .
COPY .mvn .mvn
COPY  mvnw .

# Fix permission issue for mvnw
RUN chmod +x mvnw

# Download dependencies
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Run the application using a lightweight JDK 17 image
FROM eclipse-temurin:17-jdk-alpine

# Set working directory
WORKDIR /spring-boot-ecommerce

# Copy the built jar file
COPY --from=build /spring-boot-ecommerce/target/*.jar spring-boot-ecommerce.jar

# Expose the application port
EXPOSE 9091

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "spring-boot-ecommerce.jar"]
