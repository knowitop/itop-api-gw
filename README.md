# itop-api-gw

KrakenD API Gateway преобразует RPC-стиль API iTop в RESTful API, упрощая работу с запросами и ответами.

## Зачем

- RESTful стиль — привычный для интеграций, понятные пути и HTTP-методы.
- Прямой JSON в теле запроса вместо сложного x-www-form-urlencoded с закодированным JSON.
- Упрощённый ответ — без вложенности objects и дополнительных структур.

### Сравнение API-запросов на примере создания объекта UserRequest

#### Через KrakenD API Gateway (RESTful)

Запрос:

```http request
POST http://localhost:8000/v1/UserRequest/3?output_fields=ref,title,caller_id_friendlyname
Auth-Token: <your-auth-token>
Content-Type: application/json

{
  "org_id": 3,
  "caller_id": {
    "email": "agatha.christie@demo.com",
    "status": "active",
    "org_id": "3"
  },
  "service_id": "SELECT Service WHERE name = 'Computers and peripherals'",
  "title": "New user request",
  "description": "Request description"
}
```

Ответ `201 CREATED`:

```json
{
  "code": 0,
  "message": "created",
  "class": "UserRequest",
  "key": "4",
  "fields": {
    "ref": "R-000004",
    "title": "New user request",
    "caller_id_friendlyname": "Agatha Christie"
  }
}
```

#### Стандартный API iTop (RPC-стиль)

Запрос:

```http request
POST http://localhost:8001/webservices/rest.php?version=1.4
Auth-Token: <your-auth-token>
Content-Type: application/x-www-form-urlencoded

json_data = %7B%22operation%22%3A%22core%2Fcreate%22%2C%22class%22%3A%22UserRequest%22%2C%22comment%22%3A
%22iTop+API+Gateway%22%2C%22fields%22%3A%7B%22org_id%22%3A3%2C%22caller_id%22%3A%7B%22email%22%3A
%22agatha.christie%40demo.com%22%2C%22status%22%3A%22active%22%2C%22org_id%22%3A%223%22%7D%2C
%22service_id%22%3A%22SELECT+Service+WHERE+name+%3D+%27Computers+and+peripherals%27%22%2C%22title%22%3A
%22New+user+request%22%2C%22description%22%3A%22Request+description%22%7D%2C%22output_fields%22%3A%22ref
%2Ctitle%2Ccaller_id_friendlyname%22%7D

```

Ответ `200 OK`:

```json
{
  "code": 0,
  "message": null,
  "objects": {
    "UserRequest::5": {
      "code": 0,
      "message": "created",
      "class": "UserRequest",
      "key": "5",
      "fields": {
        "ref": "R-000005",
        "title": "New user request",
        "caller_id_friendlyname": "Agatha Christie"
      }
    }
  }
}
```

## Быстро попробовать

**Запустите окружение**: `docker compose up -d`.

**Настройка iTop**

1. Перейдите в интерфейс установки: http://localhost:8001/setup.
2. Установите iTop с демо-данными и модулем Управления запросами.
3. Для доступа к API:
    - назначьте учётной записи администратора профиль REST Services User,
    - создайте персональный токен со скоупом REST/JSON,
    - либо заведите отдельную учётную запись типа Application Token.

**Swagger UI**

1. Откройте Swagger UI: http://localhost:8080.
2. Авторизуйтесь через кнопку `Authorize 🔒`, указав токен.
3. Перейдите к эндпоинту `POST /v1/{objectClass}`, нажмите `Try out` → `Execute`.
4. В iTop будет создан новый запрос.

## Настройка (WIP)

| ENV                  | Обязательно | По умолчанию            | Описание                                                                                                                                   |
|----------------------|-------------|-------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| ITOP_HOSTS           | Да          |                         | `http://host-01,http://host-02`                                                                                                            |
| ITOP_BASE_PATH       | Нет         |                         | `/itop`                                                                                                                                    |
| ITOP_API_COMMENT     | Нет         | `iTop REST API Gateway` |                                                                                                                                            |
| ITOP_AUTH_MODE       | Нет         | `token`                 | Способ аутентификации: `token` или `basic`. Соответсвующее значение должно быть указано параметре `allowed_login_types` конфигурации iTop. |
| ITOP_AUTH_TOKEN      | Нет         |                         |                                                                                                                                            |
| ITOP_AUTH_USER       | Нет         |                         |                                                                                                                                            |
| ITOP_AUTH_PWD        | Нет         |                         |                                                                                                                                            |
| ALLOW_COOKIE_HEADERS | Нет         | `0`                     |                                                                                                                                            |
| CORS_ALLOW_ORIGINS   | Нет         |                         |                                                                                                                                            |
