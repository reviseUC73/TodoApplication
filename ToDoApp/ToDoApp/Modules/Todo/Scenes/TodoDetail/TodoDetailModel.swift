//
//  TodoDetailModel.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import Foundation
import UIKit

enum TodoDetail {
    
    // MARK: - Use cases
    
    enum FetchTodoDetail {
        struct Request {
            let id: String
        }
        
        struct Response {
            let todo: Todo
        }
        
        struct ViewModel {
            let id: String
            let title: String
            let description: String
            let category: String
            let categoryColor: UIColor
            let isCompleted: Bool
            let dueDate: String?
            let createdAt: String
            let updatedAt: String
            let statusButtonTitle: String
        }
    }
    
    enum ToggleTodoStatus {
        struct Request {
            let id: String
            let isCompleted: Bool
        }
        
        struct Response {
            let todo: Todo
            let success: Bool
            let errorMessage: String?
        }
        
        struct ViewModel {
            let success: Bool
            let message: String
        }
    }
    
    enum DeleteTodo {
        struct Request {
            let id: String
        }
        
        struct Response {
            let success: Bool
            let errorMessage: String?
        }
        
        struct ViewModel {
            let success: Bool
            let message: String
        }
    }
}
