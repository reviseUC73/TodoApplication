//
//  LoginModel.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

enum Login {
    
    // MARK: - Use cases
    
    enum Login {
        struct Request {
            let username: String
            let password: String
        }
        
        struct Response {
            let success: Bool
            let errorMessage: String?
        }
        
        struct ViewModel {
            let success: Bool
            let errorMessage: String?
        }
    }
}
