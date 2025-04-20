//
//  ErrorResponse.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import Foundation

// Error Response
struct ErrorResponse: Codable {
    let status: Int
    let message: String
    let errors: [String: [String]]?
}
