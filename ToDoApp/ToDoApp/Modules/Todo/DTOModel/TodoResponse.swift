//
//  ToDoResponse.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

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
    var dueDate: Date?
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
    
    // ไม่จำเป็นต้องมี custom initializer อีกต่อไป เพราะใช้ JSONDecoder strategy จาก APIClient
    // หากมีการ debug ขอให้เก็บไว้เป็น comment เพื่อให้เห็นวิธีการทำงานเดิม
    /*
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        
        // Configure date formatter with proper formatting options
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let dueDateString = try container.decodeIfPresent(String.self, forKey: .dueDate) {
            dueDate = dateFormatter.date(from: dueDateString)
            
            // Fallback if the primary formatter fails
            if dueDate == nil {
                let fallbackFormatter = ISO8601DateFormatter()
                dueDate = fallbackFormatter.date(from: dueDateString)
                
                // Print debug info if both formatters fail
                if dueDate == nil {
                    print("Failed to parse due date: \(dueDateString)")
                }
            }
        } else {
            dueDate = nil
        }
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        createdAt = dateFormatter.date(from: createdAtString) ?? Date()
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        updatedAt = dateFormatter.date(from: updatedAtString) ?? Date()
    }
    */
}

// For response when fetching all todos
struct TodoListResponse: Codable {
    let data: [TodoResponse]
    let meta: Meta
    
    struct Meta: Codable {
        let total: Int
    }
}

// Todo model for use in the app
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
