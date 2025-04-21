# TodoApp Project

A comprehensive Todo List application with a Swift mobile client for iOS and a Node.js/Express/MongoDB backend, allowing users to efficiently manage their daily tasks.

## Project Overview

TodoApp is a full-stack solution for task management featuring:

- iOS mobile application built with Clean Swift (VIP) architecture
- RESTful API backend built with Node.js, Express, and MongoDB 
- Secure user authentication system
- Complete CRUD operations for todo management

## Application Preview

| Screen/Device | iPhone | iPad |
|---------------|--------|------|
| Login         | ![image](https://github.com/user-attachments/assets/07ea6fa2-fb08-41c4-8159-e8a7bb179637) | ![image](https://github.com/user-attachments/assets/8fa9db3b-089b-45af-990b-7caf95888331) |
| Register      | ![image](https://github.com/user-attachments/assets/475e2821-8d24-4bc4-afc9-1e146f24f8f5) | ![image](https://github.com/user-attachments/assets/95323561-eb69-4e68-9d0b-f4228a44b457) |
| Todo List     | ![image](https://github.com/user-attachments/assets/9f8baa3f-17c8-487c-94a3-4ed2e9bb2fd2) | ![image](https://github.com/user-attachments/assets/7afb493f-a875-4185-b203-d516810450a1) |
| Todo Detail   | ![image](https://github.com/user-attachments/assets/4ae650ce-ef2e-4522-9f79-e9be9846336d) | ![image](https://github.com/user-attachments/assets/74dd64d7-6642-4d39-87d9-41e064749d87) |

## Features

1. **User Authentication**
   - Secure login and registration
   - JWT-based authentication
   - Token refresh mechanism
   - Password security with hashing

2. **Todo Management**
   - Create, read, update, and delete todo items
   - Categorize todos with color coding
   - Set due dates and priorities
   - Mark completion status

3. **Filtering and Organization**
   - Filter by category or completion status
   - Sort by creation date or priority
   - Visual indicators for todo status
   - Swipe gestures for quick actions

## Technology Stack

### Mobile Client (iOS)
- **Language**: Swift 5
- **Minimum iOS Version**: iOS 14.0
- **UI Framework**: UIKit
- **Architecture**: Clean Swift (VIP)
- **Network Layer**: URLSession with protocol-oriented design
- **Persistence**: CoreData
- **Dependency Management**: Swift Package Manager
- **Testing**: XCTest

### Backend Server
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB Atlas
- **Authentication**: JWT (JSON Web Tokens)
- **Validation**: Custom middleware
- **Error Handling**: Custom error middleware
- **Container Support**: Docker

## Architecture

### iOS Client: Clean Swift (VIP)

![image](https://github.com/user-attachments/assets/9bb0b2c4-4aa3-4a88-b441-9fb0ad4f36cf)

The iOS app follows the Clean Swift architecture (VIP cycle):

1. **View Controller**: Manages UI and user interactions
2. **Interactor**: Contains business logic
3. **Presenter**: Formats data for display
4. **Worker**: Handles network and data operations
5. **Router**: Manages navigation between scenes
6. **Models**: Defines data structures for use cases

### Server: Layered Architecture

The server follows a layered architecture:

1. **Presentation Layer (Routes)**: Handles HTTP requests/responses
2. **Controller Layer**: Coordinates between routes and services
3. **Service Layer**: Implements business logic
4. **Data Access Layer (Models)**: Interacts with the database
5. **Cross-Cutting Concerns**: Middlewares, utilities, and configuration

## Database Design

The MongoDB database includes the following collections:

### Users Collection
- **Fields**:
  - `username`: String (unique)
  - `email`: String (unique)
  - `password`: String (hashed)
  - `created_at`: Date

### Todos Collection
- **Fields**:
  - `title`: String
  - `description`: String
  - `category`: String (enum values)
  - `due_date`: Date
  - `is_completed`: Boolean
  - `user`: ObjectId (reference to User)
  - `created_at`: Date
  - `updated_at`: Date

## API Endpoints

### Authentication
- `POST /auth/register`: Create new user
- `POST /auth/login`: Authenticate user
- `POST /auth/refresh`: Refresh access token
- `DELETE /auth/logout`: Invalidate current token

### Todo Management
- `GET /todos`: Retrieve all todos (with filtering)
- `POST /todos`: Create new todo
- `GET /todos/:id`: Get specific todo
- `PUT /todos/:id`: Update todo
- `DELETE /todos/:id`: Delete todo

## Project Structure

### iOS Client Structure
```
TodoApp/
├── App/
├── Assets.xcassets/
├── Base.lproj/
├── Core/
│   ├── DTOModel/
│   ├── Manager/
│   ├── Network/
│   └── Utilities/
└── Modules/
    ├── Auth/
    │   ├── DTOModel/
    │   └── Scenes/
    │       ├── Login/
    │       └── Register/
    └── Todo/
        ├── DTOModel/
        ├── Scenes/
        │   ├── AddTodo/
        │   ├── TodoDetail/
        │   └── TodoList/
        └── Views/
```

### Server Structure
```
Server/
├── config/
├── controllers/
├── logs/
├── middlewares/
├── models/
├── routes/
├── services/
├── utils/
├── .dockerignore
├── .env
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── package.json
└── server.js
```

## Installation and Setup

### Prerequisites
- macOS Ventura or later
- Xcode 14.0 or later (for iOS client)
- Node.js and npm (for server)
- MongoDB Atlas account (or local MongoDB instance)
- Git

### Server Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/reviseUC73/TodoApplication/
   cd TodoApplication/server
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file with the following variables:
   ```
   PORT=5001
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/todo-app
   JWT_SECRET=your_jwt_secret_key
   JWT_EXPIRES_IN=1h
   JWT_REFRESH_SECRET=your_jwt_refresh_secret_key
   JWT_REFRESH_EXPIRES_IN=7d
   NODE_ENV=development
   ```

4. Start the server:
   ```bash
   npm run dev
   ```

### iOS Client Setup
1. Navigate to the iOS client directory:
   ```bash
   cd TodoApplication/client
   ```

2. Open the project in Xcode:
   ```bash
   open TodoApp.xcodeproj
   ```

3. Select your development team in the Signing & Capabilities tab.

4. Configure the API base URL in the project to match your server.

5. Build and run the project (⌘+R).

## Deployment

### Server Deployment with Docker
1. Ensure Docker and Docker Compose are installed on your server.
2. Navigate to the server directory.
3. Build and run with Docker Compose:
   ```bash
   docker-compose up -d
   ```

### iOS Client Deployment
For iOS deployment, you need:
- An Apple Developer Program membership ($99/year)
- A physical device for testing connected to Xcode
- Completion of App Store Connect requirements

Without an Apple Developer Program membership, you can only:
- Run on personal devices for 7 days using a free Apple account
- Test using the iOS Simulator

## GitHub Repository
[https://github.com/reviseUC73/TodoApplication](https://github.com/reviseUC73/TodoApplication)

## Code Explanation and Architecture Decisions

### Why Clean Swift for iOS?
The Clean Swift (VIP) architecture was chosen for the iOS client because:
1. **Separation of Concerns**: Each component has a single responsibility
2. **Testability**: Interfaces defined by protocols make unit testing easier
3. **Scalability**: Components can be developed independently
4. **Maintainability**: Changes in one area don't affect others
5. **Unidirectional Data Flow**: Clear and predictable data flow between components

### Why Layered Architecture for Server?
The server uses a layered architecture because:
1. **Clear Boundaries**: Each layer has a defined responsibility
2. **Independence**: Changes in one layer don't affect others
3. **Testing**: Easier to mock dependencies for unit testing
4. **Reusability**: Components can be reused across features
5. **Maintainability**: New developers can understand the system more easily

### Security Considerations
1. **Password Security**: Passwords are hashed before storage
2. **JWT Authentication**: Short-lived access tokens with refresh capability
3. **Owner Verification**: Users can only access their own todos
4. **Input Validation**: All user inputs are validated and sanitized
5. **HTTPS**: All communication should be encrypted in production

## License

This project is licensed under the MIT License - see the LICENSE file for details. 