//
//  LoginWorker.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol LoginWorkerProtocol {
    func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class LoginWorker: LoginWorkerProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // For demonstration purposes, we'll simulate a successful login with mock credentials
        // In a real app, this would make an API call
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if username == "user" && password == "password" {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                completion(.success(true))
            } else {
                let error = NSError(domain: "LoginWorker", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password"])
                completion(.failure(error))
            }
        }
    }
}
