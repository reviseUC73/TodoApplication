//
//  TodoRequestTarget.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

enum TodoEndpoint: Endpoint {
    case getTodos
    case createTodo(title: String, description: String, category: String, dueDate: Date?)
    case updateTodo(id: String, title: String, description: String, category: String, dueDate: Date?, isCompleted: Bool)
    case deleteTodo(id: String)
    
    var baseURL: URL {
        return URL(string: "https://api.yourtodoapp.com")!
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
        // Add any authentication headers here if needed
        return ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getTodos, .deleteTodo:
            return nil
            
        case .createTodo(let title, let description, let category, let dueDate):
            var params: [String: Any] = [
                "title": title,
                "description": description,
                "category": category,
                "isCompleted": false
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
        }
    }
}
