//
//  TodoListRouter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

@objc protocol TodoListRoutingLogic {
    func routeToTodoDetail(id: String)
    func routeToAddTodo()
}

protocol TodoListDataPassing {
    var dataStore: TodoListDataStore? { get }
}

class TodoListRouter: NSObject, TodoListRoutingLogic, TodoListDataPassing {
    weak var viewController: TodoListViewController?
    var dataStore: TodoListDataStore?
    
    // MARK: - Routing
    
    func routeToTodoDetail(id: String) {
        // Implement navigation to Todo detail screen if needed
    }
    
    func routeToAddTodo() {
        let addTodoVC = AddTodoViewController()
        addTodoVC.modalPresentationStyle = .overFullScreen
        addTodoVC.modalTransitionStyle = .crossDissolve
        
        // Pass data to destination if needed
        // This is where you would pass any data needed for creating a new todo
        
        viewController?.present(addTodoVC, animated: true)
    }
}

// MARK: - AddTodoViewControllerDelegate
extension TodoListRouter {
    func addTodoViewController(_ viewController: AddTodoViewController, didAddTodoWithTitle title: String, description: String, category: TodoCategory, dueDate: Date?) {
        let request = TodoList.AddTodo.Request(
            title: title,
            description: description,
            category: category,
            dueDate: dueDate
        )
        self.viewController?.interactor?.addTodo(request: request)
    }
}
