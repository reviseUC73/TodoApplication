//
//  ToDoResponse.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

import Foundation

enum TodoCategory: String, Codable, CaseIterable {
    case work = "Work"
    case personal = "Personal"
    case shopping = "Shopping"
    case health = "Health"
    case education = "Education"
    case finance = "Finance"
    case other = "Other"
}

struct TodoResponse: Codable {
    let id: String
    let title: String
    let description: String
    let category: String
    let dueDate: Date?
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case dueDate = "due_date"
        case isCompleted = "is_completed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        
        let dateFormatter = ISO8601DateFormatter()
        
        if let dueDateString = try container.decodeIfPresent(String.self, forKey: .dueDate) {
            dueDate = dateFormatter.date(from: dueDateString)
        } else {
            dueDate = nil
        }
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        createdAt = dateFormatter.date(from: createdAtString) ?? Date()
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        updatedAt = dateFormatter.date(from: updatedAtString) ?? Date()
    }
}

// For local usage and testing when API is not available
struct Todo {
    let id: String
    var title: String
    var description: String
    var category: TodoCategory
    var dueDate: Date?
    var isCompleted: Bool
    let createdAt: Date
    var updatedAt: Date
    
    init(id: String = UUID().uuidString,
         title: String,
         description: String,
         category: TodoCategory = .work,
         dueDate: Date? = nil,
         isCompleted: Bool = false,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from response: TodoResponse) {
        self.id = response.id
        self.title = response.title
        self.description = response.description
        self.category = TodoCategory(rawValue: response.category) ?? .other
        self.dueDate = response.dueDate
        self.isCompleted = response.isCompleted
        self.createdAt = response.createdAt
        self.updatedAt = response.updatedAt
    }
}
