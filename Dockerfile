# ==========================================
# Stage 1: Build Stage using Maven & OpenJDK 17
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy POM and resolve dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build war
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Production Runtime Stage
# ==========================================
FROM eclipse-temurin:17-jre
WORKDIR /app

# Create directory for storage
RUN mkdir -p storage/documents storage/qrcodes

# Copy built artifact from build stage
COPY --from=build /app/target/*.war app.war

# Set default port (Render will override PORT environment variable dynamically)
ENV PORT=8090
EXPOSE 8090

# Run the Spring Boot application
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.war"]
