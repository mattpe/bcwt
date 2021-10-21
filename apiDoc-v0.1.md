# WOP REST API

Example API for WOP and BCWT courses

## API Reference v.0.1

#### Get all cats

```http
  GET /cat
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
  GET /cat/:cat_id
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `cat_id`      | `int` | **Required**. cat_id of cat to fetch |

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
  "cat_id": 3
}
```

#### Modify cat

```http
  PUT /cat
```

```http
  Content-type: application/json
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `name`     | `string` | **Required, min length 3** |
| `birthdate` | `date` | **Required, YYYY-MM-DD** |
| `weight`    | `number` | **Required** |
| `owner`     | `int` | **Required**, user_id of the owner|
| `cat_id`     | `int` | **Required**, cat_id of the cat|

Response:

```json
{
  "message": "cat modified"
}
```

#### Delete cat

```http
  DELETE /cat/:cat_id
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `cat_id`      | `int` | **Required**. cat_id of cat to delete |

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
  GET /user/:user_id
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `user_id`      | `int` | **Required**. user_id of user to fetch |

Response:

```json
{
  "user_id": 3,
  "name": "John Doe",
  "email": "john@metropolia.fi",
  "role": 1
}
```

#### Add user

```http
  POST /user
```

```http
  Content-type: application/json
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `name`     | `string` | **Required, min length 3** |
| `email` | `email` | **Required, email** |
| `passwd`    | `string` | **Required, min length 8 characters at least one capital letter** |

Response:

```json
{
  "message": "user added",
  "user_id": 3
}
```

#### Modify user

```http
  PUT /user
```

```http
  Content-type: application/json
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `name`     | `string` | **Required, min length 3** |
| `email` | `email` | **Required, email**  |
| `passwd`    | `number` | **Required, min length 8 characters at least one capital letter** |
| `user_id`     | `int` | **Required**, user_id of the user|

Response:

```json
{
  "message": "user modified"
}
```

#### Delete user

```http
  DELETE /user/:user_id
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
