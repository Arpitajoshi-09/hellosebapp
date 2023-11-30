# Use a Java base image from Docker Hub
FROM openjdk:latest

# Set the working directory in the container
WORKDIR /app

# Copy the Java source files to the container
COPY ./src /app/src
COPY ./test /app/test

# Compile the Java application
RUN javac src/*.java

# Run JUnit tests
RUN javac -cp .:/usr/share/java/junit.jar src/*.java test/*.java
RUN java -cp .:/usr/share/java/junit.jar:/usr/share/java/hamcrest/core.jar org.junit.runner.JUnitCore HelloTest

# Command to run the application
CMD ["java", "Main"]
