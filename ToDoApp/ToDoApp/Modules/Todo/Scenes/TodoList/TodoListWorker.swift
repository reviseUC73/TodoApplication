//
//  TodoListWorker.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol TodoListWorkerProtocol {
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void)
    func createTodo(title: String, description: String, category: TodoCategory, dueDate: Date?, completion: @escaping (Result<Todo, Error>) -> Void)
    func updateTodo(id: String, title: String, description: String, category: TodoCategory, dueDate: Date?, isCompleted: Bool, completion: @escaping (Result<Todo, Error>) -> Void)
    func deleteTodo(id: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class TodoListWorker: TodoListWorkerProtocol {
    private let apiClient: APIClientProtocol
    
    // For local testing if API is not available
    private var localTodos: [Todo] = [
        Todo(title: "Buy groceries", description: "Milk, eggs, bread", category: .shopping, dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())),
        Todo(title: "Finish project", description: "Complete the todo app", category: .work, dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())),
        Todo(title: "Call mom", description: "Ask about weekend plans", category: .personal, isCompleted: true)
    ]
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        // Uncomment this when you have a real API to use
        /*
        apiClient.request(endpoint: TodoEndpoint.getTodos) { (result: Result<[TodoResponse], APIError>) in
            switch result {
            case .success(let todoResponses):
                let todos = todoResponses.map { Todo(from: $0) }
                completion(.success(todos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        */
        
        // Using local data for now
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            completion(.success(self.localTodos))
        }
    }
    
    func createTodo(title: String, description: String, category: TodoCategory, dueDate: Date?, completion: @escaping (Result<Todo, Error>) -> Void) {
        // Uncomment this when you have a real API to use
        /*
        apiClient.request(endpoint: TodoEndpoint.createTodo(title: title, description: description, category: category.rawValue, dueDate: dueDate)) { (result: Result<TodoResponse, APIError>) in
            switch result {
            case .success(let todoResponse):
                let todo = Todo(from: todoResponse)
                completion(.success(todo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        */
        
        // Using local data for now
        let newTodo = Todo(
            title: title,
            description: description,
            category: category,
            dueDate: dueDate
        )
        localTodos.append(newTodo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(newTodo))
        }
    }
    
    func updateTodo(id: String, title: String, description: String, category: TodoCategory, dueDate: Date?, isCompleted: Bool, completion: @escaping (Result<Todo, Error>) -> Void) {
        // Uncomment this when you have a real API to use
        /*
        apiClient.request(endpoint: TodoEndpoint.updateTodo(id: id, title: title, description: description, category: category.rawValue, dueDate: dueDate, isCompleted: isCompleted)) { (result: Result<TodoResponse, APIError>) in
            switch result {
            case .success(let todoResponse):
                let todo = Todo(from: todoResponse)
                completion(.success(todo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        */
        
        // Using local data for now
        if let index = localTodos.firstIndex(where: { $0.id == id }) {
            var updatedTodo = localTodos[index]
            updatedTodo.title = title
            updatedTodo.description = description
            updatedTodo.category = category
            updatedTodo.dueDate = dueDate
            updatedTodo.isCompleted = isCompleted
            updatedTodo.updatedAt = Date()
            localTodos[index] = updatedTodo
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(updatedTodo))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.failure(NSError(domain: "TodoListWorker", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])))
            }
        }
    }
    
    func deleteTodo(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Uncomment this when you have a real API to use
        /*
        apiClient.request(endpoint: TodoEndpoint.deleteTodo(id: id)) { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        */
        
        // Using local data for now
        if let index = localTodos.firstIndex(where: { $0.id == id }) {
            localTodos.remove(at: index)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(true))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.failure(NSError(domain: "TodoListWorker", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])))
            }
        }
    }
}
