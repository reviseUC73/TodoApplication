//
//  AuthResponse.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//

import Foundation

// User Response Model
struct UserResponse: Codable {
    let id: String
    let username: String
    let email: String
    let createdAt: Date
    
    // Add this regular initializer
    init(id: String, username: String, email: String, createdAt: Date) {
        self.id = id
        self.username = username
        self.email = email
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        
        let dateFormatter = ISO8601DateFormatter()
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        createdAt = dateFormatter.date(from: createdAtString) ?? Date()
    }
}

// Auth Token Response
struct AuthTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let user: UserResponse
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case user
    }
}
