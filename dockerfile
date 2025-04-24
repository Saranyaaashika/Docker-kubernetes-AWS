# Use Maven to build the project
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy all files and build the WAR
COPY . .
RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests || cat /app/mvnw.log


# Use OpenJDK to run the WAR
FROM eclipse-temurin:17-jdk
EXPOSE 8000
WORKDIR /app

# Copy the WAR file from the build stage
COPY --from=build /app/target/*.war app.war

# Run the app
ENTRYPOINT ["java", "-jar", "app.war"]
