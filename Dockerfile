# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-slim as build

# Set the working directory in the container
WORKDIR /app

# Copy the Gradle wrapper and build files
COPY gradlew .
COPY gradle/ gradle/
COPY build.gradle .
COPY settings.gradle .

# Download and cache Gradle dependencies
RUN ./gradlew build --no-daemon

# Copy the entire source code into the container
COPY . .

# Build the JAR file
RUN ./gradlew build --no-daemon

# Use a smaller runtime base image to reduce the image size
FROM openjdk:17-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the JAR file when the container starts
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
