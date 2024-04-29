FROM openjdk:17-jdk-alpine3.14

RUN apk update

# Install tesseract library
RUN apk add --no-cache tesseract-ocr

# Download last language package
RUN mkdir -p /usr/share/tessdata
ADD https://github.com/tesseract-ocr/tessdata/blob/main/por.traineddata /usr/share/tessdata/por.traineddata


# Check the installation status
RUN tesseract --list-langs
RUN tesseract -v

# Set the location of the jar
ENV MICROSERVICE_HOME /usr/microservices

# Set the name of the jar
ENV APP_FILE CuboPDF-0.0.1-SNAPSHOT.jar

# Open the port
EXPOSE 8080

# Copy our JAR
COPY target/$APP_FILE /app.jar

# Launch the Spring Boot application
ENV JAVA_OPTS=""
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]