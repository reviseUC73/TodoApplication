//
//  TodoListWorker.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol TodoListWorkerProtocol {
    func fetchTodos(ignoreCache: Bool, completion: @escaping (Result<[Todo], Error>) -> Void)
    func createTodo(title: String, description: String, category: TodoCategory, dueDate: Date?, completion: @escaping (Result<Todo, Error>) -> Void)
    func updateTodo(id: String, title: String, description: String, category: TodoCategory, dueDate: Date?, isCompleted: Bool, completion: @escaping (Result<Todo, Error>) -> Void)
    func deleteTodo(id: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class TodoListWorker: TodoListWorkerProtocol {
    private let apiClient: APIClientProtocol
    
//    // For local testing if API is not available
//    private var localTodos: [Todo] = [
//        Todo(title: "Buy groceries", description: "Milk, eggs, bread", category: .shopping, dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())),
//        Todo(title: "Finish project", description: "Complete the todo app", category: .work, dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())),
//        Todo(title: "Call mom", description: "Ask about weekend plans", category: .personal, isCompleted: true)
//    ]
//
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchTodos(ignoreCache: Bool = false, completion: @escaping (Result<[Todo], Error>) -> Void) {
        let endpoint = TodoEndpoint.getTodos()
        
        if ignoreCache {
            // ใช้ requestFresh เพื่อบังคับให้โหลดข้อมูลใหม่
            apiClient.requestFresh(endpoint: endpoint) { (result: Result<TodoListResponse, APIError>) in
                switch result {
                case .success(let response):
                    let todos = response.data.map { Todo(from: $0) }
                    completion(.success(todos))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            // ใช้ request ปกติซึ่งอาจใช้ cache
            apiClient.request(endpoint: endpoint) { (result: Result<TodoListResponse, APIError>) in
                switch result {
                case .success(let response):
                    let todos = response.data.map { Todo(from: $0) }
                    completion(.success(todos))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func createTodo(title: String, description: String, category: TodoCategory, dueDate: Date?, completion: @escaping (Result<Todo, Error>) -> Void) {
        let endpoint = TodoEndpoint.createTodo(
            title: title,
            description: description,
            category: category.rawValue,
            dueDate: dueDate
        )
        
        apiClient.request(endpoint: endpoint) { [weak self] (result: Result<TodoResponse, APIError>) in
            switch result {
            case .success(let todoResponse):
                let todo = Todo(from: todoResponse)
                
                // ล้าง cache หลังจากสร้าง todo ใหม่
                self?.apiClient.clearCache()
                
                completion(.success(todo))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateTodo(id: String, title: String, description: String, category: TodoCategory, dueDate: Date?, isCompleted: Bool, completion: @escaping (Result<Todo, Error>) -> Void) {
        let endpoint = TodoEndpoint.updateTodo(
            id: id,
            title: title,
            description: description,
            category: category.rawValue,
            dueDate: dueDate,
            isCompleted: isCompleted
        )
        
        apiClient.request(endpoint: endpoint) { [weak self] (result: Result<TodoResponse, APIError>) in
            switch result {
            case .success(let todoResponse):
                let todo = Todo(from: todoResponse)
                
                // ล้าง cache หลังจากอัปเดต todo
                self?.apiClient.clearCache()
                
                completion(.success(todo))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTodo(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = TodoEndpoint.deleteTodo(id: id)
        
        apiClient.request(endpoint: endpoint) { [weak self] (result: Result<MessageResponse, APIError>) in
            switch result {
            case .success(_):
                // ล้าง cache หลังจากลบ todo
                self?.apiClient.clearCache()
                
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
