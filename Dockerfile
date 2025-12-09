# Stage 1 - build stage
# Build the JAR file using maven

FROM maven:3.8.3-openjdk-17 AS builder 

# Set working directory inside the container

WORKDIR /app

# Copy source code to working directory from host machine

COPY . /app

# Build application and skip test cases

RUN mvn clean install -DskipTests=true

#ENTRYPOINT ["java", "-jar", "/expenseapp.jar"]

# Stage 2 - Reexecute JAR file from the build stage

# Import small size java image

FROM openjdk:17-jdk-alpine

WORKDIR /app 

# Copy build from stage 1 (builder)

COPY --from=builder /app/target/*.jar /app/target/expenseapp.jar

# Expose application port 

EXPOSE 8080

# Start the application
CMD ["java", "-jar", "/app/target/expenseapp.jar"]
