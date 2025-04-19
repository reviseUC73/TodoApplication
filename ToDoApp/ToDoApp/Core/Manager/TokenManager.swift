//
//  TokenManager.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let expirationKey = "tokenExpiration"
    private let userIdKey = "userId"
    
    private init() {}
    
    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: accessTokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: accessTokenKey) }
    }
    
    var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: refreshTokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: refreshTokenKey) }
    }
    
    var tokenExpiration: Date? {
        get { UserDefaults.standard.object(forKey: expirationKey) as? Date }
        set { UserDefaults.standard.set(newValue, forKey: expirationKey) }
    }
    
    var userId: String? {
        get { UserDefaults.standard.string(forKey: userIdKey) }
        set { UserDefaults.standard.set(newValue, forKey: userIdKey) }
    }
    
    func isLoggedIn() -> Bool {
        return accessToken != nil
    }
    
    func isTokenValid() -> Bool {
        guard let expirationDate = tokenExpiration, let _ = accessToken else {
            return false
        }
        
        // Add a buffer of 5 minutes to ensure token refresh happens before expiration
        let buffer: TimeInterval = 5 * 60
        return expirationDate.timeIntervalSinceNow > buffer
    }
    
    func storeTokens(accessToken: String, refreshToken: String, expiresIn: Int, userId: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
        
        // Calculate expiration date
        let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
        self.tokenExpiration = expirationDate
        
        // Set logged in flag
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
        tokenExpiration = nil
        userId = nil
        
        // Clear logged in flag
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}

