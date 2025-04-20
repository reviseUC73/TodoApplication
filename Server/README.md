# Todo App Server

A RESTful API backend for a Todo application built with Node.js, Express, and MongoDB.

## Project Overview

This server provides a complete backend for a Todo application with user authentication and todo management. It follows a layered architecture pattern to maintain separation of concerns and improve maintainability.

## Architecture

The project follows a **Layered Architecture** pattern with the following layers:

### 1. Presentation Layer (Routes)
- **Purpose**: Handles HTTP requests and responses
- **Location**: `/routes` directory
- **Files**: `authRoutes.js`, `todoRoutes.js`
- **Responsibility**: Defines API endpoints and connects them to controllers

### 2. Controller Layer
- **Purpose**: Coordinates between the routes and services
- **Location**: `/controllers` directory
- **Files**: `authController.js`, `todoController.js`
- **Responsibility**: Processes requests, calls appropriate services, and returns responses

### 3. Service Layer (Business Logic)
- **Purpose**: Implements business logic and rules
- **Location**: `/services` directory
- **Files**: `authService.js`, `todoService.js`
- **Responsibility**: Contains core application logic, independent of HTTP context

### 4. Data Access Layer (Models)
- **Purpose**: Interacts with the database
- **Location**: `/models` directory
- **Files**: `User.js`, `Todo.js`
- **Responsibility**: Defines data schemas and handles database operations

### 5. Cross-Cutting Concerns
- **Middlewares**: `/middlewares` directory - Authentication, validation, error handling
- **Utils**: `/utils` directory - Helper functions, error handlers, JWT utilities
- **Config**: `/config` directory - Application and database configuration

## Database Design

The application uses **MongoDB Atlas** as its database with the following collections:

### Users Collection
- **Schema**: Defined in `/models/User.js`
- **Fields**:
  - `username`: String (unique)
  - `email`: String (unique)
  - `password`: String (hashed)
  - `created_at`: Date

### Todos Collection
- **Schema**: Defined in `/models/Todo.js`
- **Fields**:
  - `title`: String
  - `description`: String
  - `category`: String (enum: 'Work', 'Personal', 'Shopping', 'Health', 'Education', 'Finance', 'Other')
  - `due_date`: Date
  - `is_completed`: Boolean
  - `user`: ObjectId (reference to User)
  - `created_at`: Date
  - `updated_at`: Date

## API Endpoints

### Authentication

#### Register User
- **Endpoint**: `POST /auth/register`
- **Description**: Create a new user account
- **Request Body**:
  ```json
  {
    "username": "johndoe",
    "email": "john@example.com",
    "password": "securepassword123"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600,
    "user": {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "username": "johndoe",
      "email": "john@example.com",
      "created_at": "2023-04-19T08:30:00Z"
    }
  }
  ```
- **Error Response (400 Bad Request)**:
  ```json
  {
    "status": 400,
    "message": "Validation failed",
    "errors": {
      "email": ["The email must be a valid email address."],
      "password": ["The password must be at least 6 characters."]
    }
  }
  ```

#### Login
- **Endpoint**: `POST /auth/login`
- **Description**: Authenticate a user and get access token
- **Request Body**:
  ```json
  {
    "username": "johndoe",
    "password": "securepassword123"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600,
    "user": {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "username": "johndoe",
      "email": "john@example.com",
      "created_at": "2023-04-19T08:30:00Z"
    }
  }
  ```
- **Error Response (401 Unauthorized)**:
  ```json
  {
    "status": 401,
    "message": "Invalid username or password",
    "errors": null
  }
  ```

#### Refresh Token
- **Endpoint**: `POST /auth/refresh`
- **Description**: Refresh access token using a refresh token
- **Request Body**:
  ```json
  {
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpX...",
    "refresh_token": "eyJhbGciOiJIUzk3NiIsInR5cCI6IkpY...",
    "expires_in": 3600,
    "user": {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "username": "johndoe",
      "email": "john@example.com",
      "created_at": "2023-04-19T08:30:00Z"
    }
  }
  ```
- **Error Response (401 Unauthorized)**:
  ```json
  {
    "status": 401,
    "message": "Invalid refresh token",
    "errors": null
  }
  ```

#### Logout
- **Endpoint**: `DELETE /auth/logout`
- **Description**: Invalidate the current token
- **Headers**:
  ```
  Authorization: Bearer {access_token}
  ```
- **Response (200 OK)**:
  ```json
  {
    "message": "Successfully logged out"
  }
  ```

### Todo Management

#### Get All Todos
- **Endpoint**: `GET /todos`
- **Description**: Retrieve all todos for the authenticated user
- **Headers**:
  ```
  Authorization: Bearer {access_token}
  ```
- **Query Parameters**:
  - `category` (optional): Filter by category (e.g., "Work", "Personal")
  - `completed` (optional): Filter by completion status (true/false)
  - `due_date` (optional): Filter by due date (ISO 8601 format)
- **Response (200 OK)**:
  ```json
  {
    "data": [
      {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "title": "Buy groceries",
        "description": "Milk, eggs, bread",
        "category": "Shopping",
        "due_date": "2024-04-21T18:00:00Z",
        "is_completed": false,
        "created_at": "2024-04-19T10:30:00Z",
        "updated_at": "2024-04-19T10:30:00Z"
      },
      {
        "id": "223e4567-e89b-12d3-a456-426614174001",
        "title": "Finish project",
        "description": "Complete the todo app",
        "category": "Work",
        "due_date": "2024-04-23T18:00:00Z", 
        "is_completed": true,
        "created_at": "2024-04-19T09:15:00Z",
        "updated_at": "2024-04-20T14:30:00Z"
      }
    ],
    "meta": {
      "total": 2
    }
  }
  ```

#### Create Todo
- **Endpoint**: `POST /todos`
- **Description**: Create a new todo item
- **Headers**:
  ```
  Authorization: Bearer {access_token}
  Content-Type: application/json
  ```
- **Request Body**:
  ```json
  {
    "title": "Call mom",
    "description": "Ask about weekend plans",
    "category": "Personal",
    "due_date": "2024-04-22T15:30:00Z"
  }
  ```
- **Response (201 Created)**:
  ```json
  {
    "id": "323e4567-e89b-12d3-a456-426614174002",
    "title": "Call mom",
    "description": "Ask about weekend plans",
    "category": "Personal",
    "due_date": "2024-04-22T15:30:00Z",
    "is_completed": false,
    "created_at": "2024-04-20T08:45:00Z",
    "updated_at": "2024-04-20T08:45:00Z"
  }
  ```
- **Error Response (400 Bad Request)**:
  ```json
  {
    "status": 400,
    "message": "Validation failed",
    "errors": {
      "title": ["Title is required"]
    }
  }
  ```

#### Get Specific Todo
- **Endpoint**: `GET /todos/:id`
- **Description**: Get a specific todo by ID
- **Headers**:
  ```
  Authorization: Bearer {access_token}
  ```
- **Response (200 OK)**:
  ```json
  {
    "id": "323e4567-e89b-12d3-a456-426614174002",
    "title": "Call mom",
    "description": "Ask about weekend plans",
    "category": "Personal",
    "due_date": "2024-04-22T15:30:00Z",
    "is_completed": false,
    "created_at": "2024-04-20T08:45:00Z",
    "updated_at": "2024-04-20T08:45:00Z"
  }
  ```
- **Error Response (404 Not Found)**:
  ```json
  {
    "status": 404,
    "message": "Todo not found",
    "errors": null
  }
  ```

#### Update Todo
- **Endpoint**: `PUT /todos/:id`
- **Description**: Update an existing todo
- **Headers**:
  ```
  Authorization: Bearer {access_token}
  Content-Type: application/json
  ```
- **Request Body**:
  ```json
  {
    "title": "Call mom",
    "description": "Ask about weekend plans and dinner",
    "category": "Personal",
    "due_date": "2024-04-22T16:30:00Z",
    "is_completed": true
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "id": "323e4567-e89b-12d3-a456-426614174002",
    "title": "Call mom",
    "description": "Ask about weekend plans and dinner",
    "category": "Personal",
    "due_date": "2024-04-22T16:30:00Z",
    "is_completed": true,
    "created_at": "2024-04-20T08:45:00Z",
    "updated_at": "2024-04-20T09:15:00Z"
  }
  ```
- **Error Response (404 Not Found)**:
  ```json
  {
    "status": 404,
    "message": "Todo not found",
    "errors": null
  }
  ```

#### Delete Todo
- **Endpoint**: `DELETE /todos/:id`
- **Description**: Delete a todo item
- **Headers**:
  ```
  Authorization: Bearer {access_token}
  ```
- **Response (200 OK)**:
  ```json
  {
    "message": "Todo deleted successfully"
  }
  ```
- **Error Response (404 Not Found)**:
  ```json
  {
    "status": 404,
    "message": "Todo not found",
    "errors": null
  }
  ```

## Technology Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB (Atlas)
- **Authentication**: JWT (JSON Web Tokens)
- **Validation**: Custom middleware
- **Error Handling**: Custom error middleware

## Setup and Configuration

### Environment Variables
The application uses the following environment variables (stored in `.env` file):

```
PORT=5001
MONGODB_URI=mongodb+srv://rew1234:riew2545@todo-app.ogtevxl.mongodb.net/todo-app?retryWrites=true&w=majority&appName=todo-app
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=1h
JWT_REFRESH_SECRET=your_jwt_refresh_secret_key
JWT_REFRESH_EXPIRES_IN=7d
NODE_ENV=development
```

### Installation

1. Clone the repository
2. Install dependencies: `npm install`
3. Create a `.env` file with the above environment variables
4. Start the server: `npm start` or `npm run dev` for development

## Testing

A Postman collection (`todo-api-collection.json`) is included to test all API endpoints.

## Benefits of Layered Architecture

1. **Separation of Concerns**: Each layer has its own responsibility
2. **Testability**: Easier to write unit tests for isolated components
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: Each layer can be scaled independently
5. **Code Organization**: Clear structure makes code easier to navigate 