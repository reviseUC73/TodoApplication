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
        let endpoint = TodoEndpoint.createTodo(
            title: title,
            description: description,
            category: category.rawValue,
            dueDate: dueDate
        )
        
        apiClient.request(endpoint: endpoint) { [weak self] (result: Result<TodoResponse, APIError>) in
            switch result {
            case .success(_):
                // ล้าง cache หลังจากสร้าง todo ใหม่
                self?.apiClient.clearCache()
                
                // ส่ง notification ว่ามีการสร้าง todo ใหม่ บน main thread
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("TodoCreated"), object: nil)
                }
                
                // Successfully created the todo
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCategories(completion: @escaping ([TodoCategory]) -> Void) {
        // Categories are defined in the app (TodoCategory enum), no need for API call
        DispatchQueue.main.async {
            completion(TodoCategory.allCases)
        }
    }
}
