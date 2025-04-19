//
//  AuthRequestTarget.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case login(username: String, password: String)
    case register(username: String, email: String, password: String)
    case refreshToken(refreshToken: String)
    case logout
    
    var baseURL: URL {
        return URL(string: "https://api.yourtodoapp.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .refreshToken:
            return "/auth/refresh"
        case .logout:
            return "/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register, .refreshToken:
            return .post
        case .logout:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        
        // Add Authorization header for endpoints that require authentication
        if case .logout = self {
            if let token = TokenManager.shared.accessToken {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        
        return headers
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let username, let password):
            return [
                "username": username,
                "password": password
            ]
            
        case .register(let username, let email, let password):
            return [
                "username": username,
                "email": email,
                "password": password
            ]
            
        case .refreshToken(let refreshToken):
            return [
                "refresh_token": refreshToken
            ]
            
        case .logout:
            return nil
        }
    }
}

