//
//  LoginWorker.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol LoginWorkerProtocol {
    func login(username: String, password: String, completion: @escaping (Result<AuthTokenResponse, Error>) -> Void)
    func refreshToken(completion: @escaping (Result<AuthTokenResponse, Error>) -> Void)
    func logout(completion: @escaping (Result<Bool, Error>) -> Void)
}

class LoginWorker: LoginWorkerProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func login(username: String, password: String, completion: @escaping (Result<AuthTokenResponse, Error>) -> Void) {
        // For a real implementation:
        // apiClient.request(endpoint: AuthEndpoint.login(username: username, password: password), completion: completion)
        
        // For demo purposes with mock data:
        let workItem = DispatchWorkItem {
            if username == "user" && password == "password" {
                // Mock successful response
                let mockUser = UserResponse(
                    id: "user123",
                    username: "user",
                    email: "user@example.com",
                    createdAt: Date()
                )
                
                let mockResponse = AuthTokenResponse(
                    accessToken: "mock_access_token_12345",
                    refreshToken: "mock_refresh_token_67890",
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
            } else {
                let error = NSError(domain: "LoginWorker", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password"])
                completion(.failure(error))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
    func refreshToken(completion: @escaping (Result<AuthTokenResponse, Error>) -> Void) {
        guard let refreshToken = TokenManager.shared.refreshToken else {
            let error = NSError(domain: "LoginWorker", code: 401, userInfo: [NSLocalizedDescriptionKey: "No refresh token available"])
            completion(.failure(error))
            return
        }
        
        // For a real implementation:
        // apiClient.request(endpoint: AuthEndpoint.refreshToken(refreshToken: refreshToken), completion: completion)
        
        // For demo purposes with mock data:
        let workItem = DispatchWorkItem {
            // Mock successful refresh response
            let mockUser = UserResponse(
                id: TokenManager.shared.userId ?? "user123",
                username: "user",
                email: "user@example.com",
                createdAt: Date()
            )
            
            let mockResponse = AuthTokenResponse(
                accessToken: "new_mock_access_token_\(UUID().uuidString.prefix(8))",
                refreshToken: "new_mock_refresh_token_\(UUID().uuidString.prefix(8))",
                expiresIn: 3600, // 1 hour
                user: mockUser
            )
            
            // Update tokens in token manager
            TokenManager.shared.storeTokens(
                accessToken: mockResponse.accessToken,
                refreshToken: mockResponse.refreshToken,
                expiresIn: mockResponse.expiresIn,
                userId: mockResponse.user.id
            )
            
            completion(.success(mockResponse))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        // For a real implementation:
        // apiClient.request(endpoint: AuthEndpoint.logout, completion: completion)
        
        // For demo purposes:
        let workItem = DispatchWorkItem {
            // Clear tokens
            TokenManager.shared.clearTokens()
            completion(.success(true))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}
