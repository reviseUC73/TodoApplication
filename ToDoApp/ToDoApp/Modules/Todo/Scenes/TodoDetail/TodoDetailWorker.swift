//
//  TodoDetailWorker.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import Foundation

protocol TodoDetailWorkerLogic {
    func fetchTodoDetail(id: String, completion: @escaping (Result<Todo, Error>) -> Void)
    func updateTodoStatus(id: String, title: String, description: String, category: String, dueDate: Date?, isCompleted: Bool, completion: @escaping (Result<Todo, Error>) -> Void)
    func deleteTodo(id: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class TodoDetailWorker: TodoDetailWorkerLogic {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchTodoDetail(id: String, completion: @escaping (Result<Todo, Error>) -> Void) {
        // เรียกใช้ API เพื่อดึงข้อมูล Todo ตาม ID
        // ในกรณีนี้ ยังไม่มี API เฉพาะสำหรับดึง todo เดียว จึงต้องดึงทั้งหมดแล้วกรอง
        
        let endpoint = TodoEndpoint.getTodos()
        
        apiClient.request(endpoint: endpoint) { (result: Result<TodoListResponse, APIError>) in
            switch result {
            case .success(let response):
                // กรองเฉพาะ todo ที่มี ID ตรงกับที่ต้องการ
                if let todoResponse = response.data.first(where: { $0.id == id }) {
                    let todo = Todo(from: todoResponse)
                    completion(.success(todo))
                } else {
                    completion(.failure(APIError.notFound))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateTodoStatus(id: String, title: String, description: String, category: String, dueDate: Date?, isCompleted: Bool, completion: @escaping (Result<Todo, Error>) -> Void) {
        let endpoint = TodoEndpoint.updateTodo(
            id: id,
            title: title,
            description: description,
            category: category,
            dueDate: dueDate,
            isCompleted: isCompleted
        )
        
        apiClient.request(endpoint: endpoint) { (result: Result<TodoResponse, APIError>) in
            switch result {
            case .success(let todoResponse):
                let todo = Todo(from: todoResponse)
                
                // ล้าง cache เพื่อให้แน่ใจว่าจะโหลดข้อมูลใหม่เมื่อกลับไปหน้า list
                self.apiClient.clearCache()
                
                completion(.success(todo))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTodo(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = TodoEndpoint.deleteTodo(id: id)
        
        apiClient.request(endpoint: endpoint) { (result: Result<MessageResponse, APIError>) in
            switch result {
            case .success(_):
                // ล้าง cache เพื่อให้แน่ใจว่าจะโหลดข้อมูลใหม่เมื่อกลับไปหน้า list
                self.apiClient.clearCache()
                
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
