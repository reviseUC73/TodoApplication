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
        let endpoint = AuthEndpoint.login(username: username, password: password)
        
        apiClient.request(endpoint: endpoint) { (result: Result<AuthTokenResponse, APIError>) in
            switch result {
            case .success(let response):
                // Store tokens in token manager
                TokenManager.shared.storeTokens(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    expiresIn: response.expiresIn,
                    userId: response.user.id
                )
                
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func refreshToken(completion: @escaping (Result<AuthTokenResponse, Error>) -> Void) {
        guard let refreshToken = TokenManager.shared.refreshToken else {
            let error = NSError(domain: "LoginWorker", code: 401, userInfo: [NSLocalizedDescriptionKey: "No refresh token available"])
            completion(.failure(error))
            return
        }
        
        let endpoint = AuthEndpoint.refreshToken(refreshToken: refreshToken)
        
        apiClient.request(endpoint: endpoint) { (result: Result<AuthTokenResponse, APIError>) in
            switch result {
            case .success(let response):
                // Update tokens in token manager
                TokenManager.shared.storeTokens(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    expiresIn: response.expiresIn,
                    userId: response.user.id
                )
                
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = AuthEndpoint.logout
        
        // For logout, we expect a message response
        apiClient.request(endpoint: endpoint) { (result: Result<MessageResponse, APIError>) in
            switch result {
            case .success(_):
                // Clear tokens
                TokenManager.shared.clearTokens()
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
