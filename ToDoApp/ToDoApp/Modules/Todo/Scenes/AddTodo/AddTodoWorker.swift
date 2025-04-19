//
//  AddTodoWorker.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol AddTodoWorkerProtocol {
    func createTodo(title: String, description: String, category: TodoCategory, dueDate: Date?, completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchCategories(completion: @escaping ([TodoCategory]) -> Void)
}

class AddTodoWorker: AddTodoWorkerProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func createTodo(title: String, description: String, category: TodoCategory, dueDate: Date?, completion: @escaping (Result<Bool, Error>) -> Void) {
        // In a real app, you would make an API call here
        // For now, we'll just simulate a successful creation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(true))
        }
    }
    
    func fetchCategories(completion: @escaping ([TodoCategory]) -> Void) {
        // In a real app, you might fetch categories from an API
        // For now, we'll just return all available categories
        
        DispatchQueue.main.async {
            completion(TodoCategory.allCases)
        }
    }
}
