# Etap 1: Budowanie aplikacji za pomocą Mavena
FROM maven:3.8.6 AS build

# Ustawienie katalogu roboczego w kontenerze
WORKDIR /app

# Skopiowanie pliku pom.xml (zależności)
COPY pom.xml .

# Pobranie zależności (aby nie pobierać ich za każdym razem)
RUN mvn dependency:go-offline

# Skopiowanie kodu źródłowego do kontenera
COPY src ./src

# Kompilacja aplikacji
RUN mvn clean package -DskipTests

# Etap 2: Uruchomienie aplikacji w OpenJDK
FROM openjdk:17-jdk-slim

# Skopiowanie zbudowanego pliku JAR z poprzedniego etapu
COPY --from=build /app/target/demoDockerCompose-0.0.1-SNAPSHOT.jar /app/demo.jar


# Ustawienie katalogu roboczego w kontenerze
WORKDIR /app

# Uruchomienie aplikacji
CMD ["java", "-jar", "demo.jar"]

