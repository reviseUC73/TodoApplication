//
//  TodoRequestTarget.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

enum TodoList {
    
    // MARK: - Use cases
    
    enum FetchTodos {
        struct Request {}
        
        struct Response {
            var todos: [Todo]
        }
        
        struct ViewModel {
            struct DisplayedTodo {
                let id: String
                let title: String
                let description: String
                let category: TodoCategory
                let dueDate: Date?
                let isCompleted: Bool
                let formattedDate: String
                let formattedDueDate: String?
            }
            var displayedTodos: [DisplayedTodo]
        }
    }
    
    enum AddTodo {
        struct Request {
            let title: String
            let description: String
            let category: TodoCategory
            let dueDate: Date?
        }
        
        struct Response {
            let todo: Todo
        }
        
        struct ViewModel {
            let message: String
        }
    }
    
    enum ToggleTodoStatus {
        struct Request {
            let id: String
            let isCompleted: Bool
        }
        
        struct Response {
            let todo: Todo
        }
        
        struct ViewModel {
            let message: String
        }
    }
    
    enum DeleteTodo {
        struct Request {
            let id: String
        }
        
        struct Response {
            let success: Bool
        }
        
        struct ViewModel {
            let message: String
        }
    }
}
