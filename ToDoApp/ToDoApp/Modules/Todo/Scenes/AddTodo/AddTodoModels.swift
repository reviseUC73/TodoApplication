//
//  AddTodoModels.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

enum AddTodo {
    
    // MARK: - Use cases
    
    enum Create {
        struct Request {
            let title: String
            let description: String
            let category: TodoCategory
            let dueDate: Date?
        }
        
        struct Response {
            let success: Bool
            let error: Error?
        }
        
        struct ViewModel {
            let success: Bool
            let errorMessage: String?
        }
    }
    
    enum FetchCategories {
        struct Request {}
        
        struct Response {
            let categories: [TodoCategory]
        }
        
        struct ViewModel {
            let categories: [String]
        }
    }
}
