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
- `POST /auth/register` - Create a new user account
- `POST /auth/login` - Authenticate a user and get access token
- `POST /auth/refresh` - Refresh access token using a refresh token
- `DELETE /auth/logout` - Invalidate the current token

### Todo Management
- `GET /todos` - Retrieve all todos for the authenticated user
- `POST /todos` - Create a new todo item
- `GET /todos/:id` - Get a specific todo by ID
- `PUT /todos/:id` - Update an existing todo
- `DELETE /todos/:id` - Delete a todo

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