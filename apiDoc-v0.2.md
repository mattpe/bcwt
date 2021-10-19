# WOP REST API

Example API for WOP and BCWT courses

## API Reference v.0.2

#### Login

```http
  POST /auth/login
```

```http
  Content-type: application/json
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `username` | `email` | **Required** |
| `password`    | `string` | **Required** |

Response:

```json
{
  "user": {
    "user_id": 3,
    "name": "John Doe",
    "email": "john@metropolia.fi",
    "role": 1
  },
  "token": "ajkshdfghjagweurytkjhasgdfyawkegfo8734y5uiga8go7y4akgjhdf"
}
```

#### Register (was Add user)

```http
  POST /auth/register
```

```http
  Content-type: application/json
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `name`     | `string` | **Required, min length 3** |
| `email` | `email` | **Required, email** |
| `passwd`    | `string` | **Required, min length 8 characters, at least one capital letter** |

Response:

```json
{
  "message": "user added",
  "id": 3
}
```

#### Get all cats

```http
  GET /cat
```

```http
  Authorization: Bearer token
```

Response:

```json
[
  {
    "cat_id": 2,
    "name": "Catname",
    "weight": 5,
    "owner": 3,
    "filename": "f3dbafa319a4d01dcf4f140fb7576eb6",
    "birthdate": "2021-10-12",
    "ownername": "John Doe"
  }
]
```

#### Get one cat

```http
  GET /cat/:id
```

```http
  Authorization: Bearer token
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `int` | **Required**. Id of cat to fetch |

Response:

```json
{
  "cat_id": 2,
  "name": "Catname",
  "weight": 5,
  "owner": 3,
  "filename": "f3dbafa319a4d01dcf4f140fb7576eb6",
  "birthdate": "2021-10-12",
  "ownername": "John Doe"
}
```

#### Add cat

```http
  POST /cat
```

```http
  Authorization: Bearer token
```

```http
  Content-type: multipart/form-data
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `name`     | `string` | **Required, min length 3** |
| `birthdate` | `date` | **Required, YYYY-MM-DD** |
| `weight`    | `number` | **Required** |
| `owner`     | `int` | **Required**, user_id of the owner|
| `cat`       | `file` | **Required, jpg, png, gif** |

Response:

```json
{
  "message": "cat added",
  "id": 3
}
```

#### Modify cat

```http
  PUT /cat/:id
```

```http
  Authorization: Bearer token
```

```http
  Content-type: application/json
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`     | `int` | **Required**, cat_id of the cat|
| `name`     | `string` | **Optional, min length 3** |
| `birthdate` | `date` | **Optional, YYYY-MM-DD** |
| `weight`    | `number` | **Optional** |
| `owner`     | `int` | **Optional**, user_id of the owner, admin only|

Response:

```json
{
  "message": "cat modified"
}
```

#### Delete cat

```http
  DELETE /cat/:id
```

```http
  Authorization: Bearer token
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `int` | **Required**. Id of cat to delete |

Response:

```json
{
  "message": "cat deleted"
}
```

#### Get all users

```http
  GET /user
```

```http
  Authorization: Bearer token
```

Response:

```json
[
  {
    "user_id": 3,
    "name": "John Doe",
    "email": "john@metropolia.fi",
    "role": 1
  }
]
```

#### Get one user

```http
  GET /user/:id
```

```http
  Authorization: Bearer token
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `cat_id`      | `int` | **Required**. cat_id of user to fetch |

Response:

```json
{
  "user_id": 3,
  "name": "John Doe",
  "email": "john@metropolia.fi",
  "role": 1
}
```

#### Modify user

```http
  PUT /user/:id
```

```http
  Authorization: Bearer token
```

```http
  Content-type: application/json
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`     | `int` | **Required**, user_id of the user|
| `name`     | `string` | **Optional, min length 3** |
| `email` | `email` | **Optional, email**  |
| `passwd`    | `number` | **Optional, min length 8 characters, at least one capital letter** |

Response:

```json
{
  "message": "user modified"
}
```

#### Delete user

```http
  DELETE /user/:id
```

```http
  Authorization: Bearer token
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `user_id`      | `int` | **Required**. user_id of the user to delete |

Response:

```json
{
  "message": "user deleted"
}
```
