//
//  TodoDetailPresenter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import Foundation
import UIKit

protocol TodoDetailPresentationLogic {
    func presentTodoDetail(response: TodoDetail.FetchTodoDetail.Response)
    func presentToggledTodoStatus(response: TodoDetail.ToggleTodoStatus.Response)
    func presentDeletedTodo(response: TodoDetail.DeleteTodo.Response)
}

class TodoDetailPresenter: TodoDetailPresentationLogic {
    weak var viewController: TodoDetailDisplayLogic?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    func presentTodoDetail(response: TodoDetail.FetchTodoDetail.Response) {
        let todo = response.todo
        
        // กำหนดสีตามประเภท
        let categoryColor: UIColor
        switch todo.category {
        case .work:
            categoryColor = UIColor.systemBlue
        case .personal:
            categoryColor = UIColor.systemPurple
        case .shopping:
            categoryColor = UIColor.systemGreen
        case .health:
            categoryColor = UIColor.systemRed
        case .education:
            categoryColor = UIColor.systemOrange
        case .finance:
            categoryColor = UIColor.systemTeal
        case .other:
            categoryColor = UIColor.systemGray
        }
        
        // จัดรูปแบบวันที่
        let formattedDueDate = todo.dueDate.map { dateFormatter.string(from: $0) }
        let formattedCreatedAt = dateFormatter.string(from: todo.createdAt)
        let formattedUpdatedAt = dateFormatter.string(from: todo.updatedAt)
        
        // กำหนดข้อความปุ่ม toggle status
        let statusButtonTitle = todo.isCompleted ? "Mark as Not Completed" : "Mark as Completed"
        
        let viewModel = TodoDetail.FetchTodoDetail.ViewModel(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            category: todo.category.rawValue,
            categoryColor: categoryColor,
            isCompleted: todo.isCompleted,
            dueDate: formattedDueDate,
            createdAt: formattedCreatedAt,
            updatedAt: formattedUpdatedAt,
            statusButtonTitle: statusButtonTitle
        )
        
        viewController?.displayTodoDetail(viewModel: viewModel)
    }
    
    func presentToggledTodoStatus(response: TodoDetail.ToggleTodoStatus.Response) {
        let message: String
        
        if response.success {
            message = response.todo.isCompleted ? 
                "Todo marked as completed" : 
                "Todo marked as not completed"
        } else {
            message = "Failed to update status: \(response.errorMessage ?? "Unknown error")"
        }
        
        let viewModel = TodoDetail.ToggleTodoStatus.ViewModel(
            success: response.success,
            message: message
        )
        
        viewController?.displayToggledTodoStatus(viewModel: viewModel)
    }
    
    func presentDeletedTodo(response: TodoDetail.DeleteTodo.Response) {
        let message: String
        
        if response.success {
            message = "Todo deleted successfully"
        } else {
            message = "Failed to delete todo: \(response.errorMessage ?? "Unknown error")"
        }
        
        let viewModel = TodoDetail.DeleteTodo.ViewModel(
            success: response.success,
            message: message
        )
        
        viewController?.displayDeletedTodo(viewModel: viewModel)
    }
}
