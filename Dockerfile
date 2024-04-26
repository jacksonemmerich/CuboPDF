FROM openjdk:17-jre-alpine AS MAVEN_BUILD

RUN apk update && apk add --no-cache build-base

# Tesseract OCR library
RUN apk add --no-cache tesseract-ocr

# Download latest Italian language pack (replace with desired language)
RUN mkdir -p /usr/share/tessdata
ADD https://github.com/tesseract-ocr/tessdata/blob/main/por.traineddata /usr/share/tessdata/por.traineddata

# Verify installation
RUN tesseract --list-langs
RUN tesseract -v

# Copy the JAR to a staging directory
COPY target/*.jar /app.jar

# Final image (slim)
FROM openjdk:17-alpine3.14

WORKDIR /usr/app

# Copy JAR from builder stage
COPY --from=builder /app.jar .

# Set environment variables
ENV MICROSERVICE_HOME /usr/microservices
ENV APP_FILE CuboOCR-0.0.1-SNAPSHOT.jar

# Expose port
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT [ "java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "$APP_FILE" ]
