# TodoApp

A comprehensive todo list application built with Clean Swift architecture, helping users manage their daily tasks efficiently.

## Application Preview

| Screen/Device | iPhone | iPad |
|---------------|--------|------|
| Login         |    ![image](https://github.com/user-attachments/assets/07ea6fa2-fb08-41c4-8159-e8a7bb179637) |    ![image](https://github.com/user-attachments/assets/8fa9db3b-089b-45af-990b-7caf95888331)|
| Register      |      ![image](https://github.com/user-attachments/assets/475e2821-8d24-4bc4-afc9-1e146f24f8f5) |  ![image](https://github.com/user-attachments/assets/95323561-eb69-4e68-9d0b-f4228a44b457) |
| Todo List     |     ![image](https://github.com/user-attachments/assets/9f8baa3f-17c8-487c-94a3-4ed2e9bb2fd2)| |![image](https://github.com/user-attachments/assets/7afb493f-a875-4185-b203-d516810450a1)
| Todo Detail   |  ![image](https://github.com/user-attachments/assets/4ae650ce-ef2e-4522-9f79-e9be9846336d)|      |![image](https://github.com/user-attachments/assets/74dd64d7-6642-4d39-87d9-41e064749d87)

## Features

1. **User Authentication**
   - Login and signup functionality
   - Secure user authentication
   - Password recovery option

2. **Todo List Management**
   - View all todo items with category color coding
   - Filter todos by category or completion status
   - Swipe interactions for quick actions

3. **Todo Creation and Editing**
   - Add new todo items with title, description, due date, and category
   - Edit existing todo details
   - Set priority levels for tasks

4. **Status Management**
   - Mark todos as complete/incomplete with a simple tap
   - Visual indicators for todo status (empty circle vs. checkmark)

5. **Todo Deletion**
   - Remove todo items from the list
   - Confirmation before deletion to prevent mistakes

## Technology Stack

- **Language**: Swift 5
- **Minimum iOS Version**: iOS 14.0
- **UI Framework**: UIKit
- **Architecture**: Clean Swift (VIP)
- **Network Layer**: URLSession with protocol-oriented design
- **Persistence**: CoreData
- **Dependency Management**: Swift Package Manager
- **Testing**: XCTest

## Project Structure

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

## Clean Swift Architecture (VIP)

![image](https://github.com/user-attachments/assets/9bb0b2c4-4aa3-4a88-b441-9fb0ad4f36cf)


The project follows the Clean Swift architecture (VIP cycle), which consists of the following components:

### Components

1. **View Controller**
   - Manages UI elements and user interactions
   - Forwards user actions to the Interactor
   - Displays formatted data from the Presenter
   - Follows the display logic protocol defined by the Presenter

2. **Interactor**
   - Contains business logic
   - Processes requests from the View Controller
   - Communicates with the Worker for network requests and data operations
   - Sends responses to the Presenter for formatting
   - Acts as the source of truth for the scene

3. **Presenter**
   - Formats data for display
   - Converts raw business models into view models
   - Sends formatted data back to the View Controller
   - Does not contain business logic

4. **Worker**
   - Handles network operations and data persistence
   - Communicates with API services
   - Abstracts data access layer from the Interactor
   - Processes business logic data operations

5. **Router**
   - Manages navigation between scenes
   - Handles data passing between scenes
   - Creates and configures destination view controllers

6. **Models**
   - Defines data structures for each use case
   - Contains Request, Response, and ViewModel models
   - Ensures clean data flow between components

### Data Flow

1. View Controller captures user input
2. View Controller requests Interactor to process that input
3. Interactor works with Worker to fetch or process data
4. Interactor sends result to Presenter
5. Presenter formats the response for display
6. View Controller displays the formatted data
7. Router handles navigation between scenes

## Installation

### Requirements
- macOS Ventura or later
- Xcode 14.0 or later
- iOS 14.0 or later

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/reviseUC73/TodoApplication
   cd TodoApp
   ```

2. Open the project in Xcode:
   ```bash
   open TodoApp.xcodeproj
   ```

3. Select your development team in the Signing & Capabilities tab.

4. Build and run the project (⌘+R).

## Application Deployment

### Development Testing
1. Connect your iPhone or iPad to your Mac.
2. Select your device from the Xcode device menu.
3. Click the "Run" button or press ⌘+R to build and run the app on your device.

### Simulator Testing
1. Select an iOS Simulator from the Xcode device menu.
2. Click the "Run" button or press ⌘+R to build and run the app in the simulator.

### App Store Deployment
App Store deployment is not currently possible as it requires:
- An Apple Developer Program membership ($99/year)
- A physical device for testing connected to Xcode
- Completion of App Store Connect requirements

Without an Apple Developer Program membership, you can only:
- Run on personal devices for 7 days using a free Apple account
- Test using the iOS Simulator

## Best Practices

- **Physical Device Testing**: Always test on real devices before deployment
- **Memory Management**: The app uses ARC (Automatic Reference Counting)
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Accessibility**: Support for VoiceOver and Dynamic Type
- **Localization**: Ready for multiple language support
- **Security**: Secure storage for sensitive user data

## What Makes This Project Great

1. **Clean Architecture**: The VIP cycle ensures separation of concerns and testability
2. **Protocol-Oriented Design**: Interfaces defined by protocols for better testing and modularity
3. **Reusable Components**: Custom UI elements can be reused across the app
4. **Responsive UI**: Works seamlessly on both iPhone and iPad (universal app)
5. **Modern Swift Practices**: Uses Swift's latest features for safe and efficient code

## License

This project is licensed under the MIT License - see the LICENSE file for details. 
