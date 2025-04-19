//
//  RegisterModels.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//

import Foundation

enum Register {
    
    // MARK: - Use cases
    
    enum Register {
        struct Request {
            let username: String
            let email: String
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
