# Booking — практическая работа №1 (Jakarta EE)

Приложение для бронирования номеров: клиенты и бронирования
(добавление, редактирование, удаление).

## Архитектура

| Слой | Технология | Файлы |
|---|---|---|
| Данные | JPA-сущности (Java Beans), PostgreSQL | `entity/Client`, `entity/Booking`, `entity/BookingStatus`, `persistence.xml`, `init_database.sql` |
| Бизнес-логика | Сессионные EJB `@Stateless` | `ejb/ClientServiceBean`, `ejb/BookingServiceBean` |
| Представление | Servlet + JSP (Bootstrap) | `web/MainServlet`, `WEB-INF/views/index.jsp` |

Сервер приложений — Payara Server (форк GlassFish), СУБД — PostgreSQL 16.

## Запуск

```bash
cp .env.example .env        # необязательно: по умолчанию booking/booking/booking
docker compose up --build
```

- Приложение: http://localhost:8080/booking/
- Консоль администратора: https://localhost:4848 (admin / admin)

При старте сервер выполняет команды из `post-boot-commands.asadmin`
(создаёт пул `bookingPool` и ресурс `jdbc/bookingDS`) и разворачивает
`booking.war` из каталога `/opt/payara/deployments`.
Скрипт `init_database.sql` выполняется PostgreSQL при первом создании БД.

> Если меняете данные БД в `.env`, поменяйте их и в `post-boot-commands.asadmin`.
> Чтобы заново выполнить `init_database.sql`, удалите старую БД: `docker compose down -v`.

## Ручное развёртывание через консоль администратора (альтернатива)

1. Собрать WAR: `mvn clean package` → `target/booking.war`.
2. Положить `postgresql-42.7.4.jar` в `glassfish/domains/domain1/lib`, перезапустить домен.
3. *Resources → JDBC → JDBC Connection Pools → New*: `bookingPool`,
   тип `javax.sql.DataSource`, класс `org.postgresql.ds.PGSimpleDataSource`,
   свойства `user`, `password`, `databaseName`, `serverName`, `portNumber`. Проверить кнопкой *Ping*.
4. *JDBC Resources → New*: `jdbc/bookingDS` → пул `bookingPool`.
5. *Applications → Deploy* → выбрать `booking.war`.
