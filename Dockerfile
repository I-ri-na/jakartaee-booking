# ---------- Сборка WAR ----------
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
COPY src ./src

# Собираем WAR и отдельно копируем JDBC-драйвер PostgreSQL (той же версии, что в pom.xml)
RUN mvn -B -Dmaven.test.skip=true clean package \
 && mvn -B dependency:copy-dependencies -DincludeArtifactIds=postgresql -DoutputDirectory=/app/lib

# ---------- Сервер приложений ----------
FROM payara/server-full:6.2024.12-jdk17

# Драйвер должен лежать в lib домена, чтобы его видел пул соединений сервера
COPY --from=builder --chown=payara:payara /app/lib/*.jar /opt/payara/appserver/glassfish/domains/domain1/lib/

# Команды asadmin, выполняемые при старте: пул соединений + JDBC-ресурс
COPY --chown=payara:payara post-boot-commands.asadmin /opt/payara/config/post-boot-commands.asadmin

# Приложение разворачивается сервером из каталога deployments при старте
COPY --from=builder --chown=payara:payara /app/target/booking.war /opt/payara/deployments/booking.war
