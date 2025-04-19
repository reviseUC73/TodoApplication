//
//  RegisterWorker.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//

import Foundation

protocol RegisterWorkerProtocol {
    func register(username: String, email: String, password: String, completion: @escaping (Result<AuthTokenResponse, Error>) -> Void)
}

class RegisterWorker: RegisterWorkerProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func register(username: String, email: String, password: String, completion: @escaping (Result<AuthTokenResponse, Error>) -> Void) {
        // For demonstration purposes, we'll simulate a successful registration
        // In a real app, this would make an API call to register the user
        
        // Validate email format
        guard isValidEmail(email) else {
            let error = NSError(domain: "RegisterWorker", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid email format"])
            completion(.failure(error))
            return
        }
        
        // Validate password strength
        guard isStrongPassword(password) else {
            let error = NSError(domain: "RegisterWorker", code: 400, userInfo: [NSLocalizedDescriptionKey: "Password must be at least 6 characters and contain a number"])
            completion(.failure(error))
            return
        }
        
        // Simulate network delay
        let workItem = DispatchWorkItem {
            // For demo purposes, let's say users with "test@example.com" already exist
            if email.lowercased() == "test@example.com" {
                let error = NSError(domain: "RegisterWorker", code: 409, userInfo: [NSLocalizedDescriptionKey: "User with this email already exists"])
                completion(.failure(error))
                return
            }
            
            // Mock successful registration response
            let mockUser = UserResponse(
                id: "user_\(UUID().uuidString.prefix(8))",
                username: username,
                email: email,
                createdAt: Date()
            )
            
            let mockResponse = AuthTokenResponse(
                accessToken: "mock_access_token_\(UUID().uuidString.prefix(8))",
                refreshToken: "mock_refresh_token_\(UUID().uuidString.prefix(8))",
                expiresIn: 3600, // 1 hour
                user: mockUser
            )
            
            // Store tokens in token manager
            TokenManager.shared.storeTokens(
                accessToken: mockResponse.accessToken,
                refreshToken: mockResponse.refreshToken,
                expiresIn: mockResponse.expiresIn,
                userId: mockResponse.user.id
            )
            
            completion(.success(mockResponse))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
    }
    
    // MARK: - Validation Helpers
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isStrongPassword(_ password: String) -> Bool {
        // Simple validation: at least 6 characters and contains a number
        return password.count >= 6 && password.rangeOfCharacter(from: .decimalDigits) != nil
    }
}
