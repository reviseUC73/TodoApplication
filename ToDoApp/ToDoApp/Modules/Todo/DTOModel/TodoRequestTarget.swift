//
//  TodoRequestTarget.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

enum TodoEndpoint: Endpoint {
    case getTodos(category: String? = nil, completed: Bool? = nil, dueDate: Date? = nil)
    case createTodo(title: String, description: String, category: String, dueDate: Date?)
    case updateTodo(id: String, title: String, description: String, category: String, dueDate: Date?, isCompleted: Bool)
    case deleteTodo(id: String)
    
    var baseURL: URL {
        return URL(string: "http://localhost:5001")!
    }
    
    var path: String {
        switch self {
        case .getTodos:
            return "/todos"
        case .createTodo:
            return "/todos"
        case .updateTodo(let id, _, _, _, _, _):
            return "/todos/\(id)"
        case .deleteTodo(let id):
            return "/todos/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTodos:
            return .get
        case .createTodo:
            return .post
        case .updateTodo:
            return .put
        case .deleteTodo:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        
        // Add token for authentication
        if let token = TokenManager.shared.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    var requiresAuthentication: Bool {
        return true
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getTodos(let category, let completed, let dueDate):
            var params: [String: Any] = [:]
            
            if let category = category {
                params["category"] = category
            }
            
            if let completed = completed {
                params["completed"] = completed
            }
            
            if let dueDate = dueDate {
                let dateFormatter = ISO8601DateFormatter()
                params["due_date"] = dateFormatter.string(from: dueDate)
            }
            
            return params.isEmpty ? nil : params
            
        case .createTodo(let title, let description, let category, let dueDate):
            var params: [String: Any] = [
                "title": title,
                "description": description,
                "category": category
            ]
            
            if let dueDate = dueDate {
                let dateFormatter = ISO8601DateFormatter()
                params["due_date"] = dateFormatter.string(from: dueDate)
            }
            
            return params
            
        case .updateTodo(_, let title, let description, let category, let dueDate, let isCompleted):
            var params: [String: Any] = [
                "title": title,
                "description": description,
                "category": category,
                "is_completed": isCompleted
            ]
            
            if let dueDate = dueDate {
                let dateFormatter = ISO8601DateFormatter()
                params["due_date"] = dateFormatter.string(from: dueDate)
            }
            
            return params
            
        case .deleteTodo:
            return nil
        }
    }
}
