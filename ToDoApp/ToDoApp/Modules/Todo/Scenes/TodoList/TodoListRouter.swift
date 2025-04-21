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
        // Find the todo with the given ID
        guard let todo = dataStore?.todos.first(where: { $0.id == id }) else { return }
        
        // Create and configure the TodoDetailViewController
        let todoDetailVC = TodoDetailViewController()
        
        // Set up todo in the dataStore of the detailVC
        if var destinationDS = todoDetailVC.router?.dataStore {
            destinationDS.todo = todo
        }
        
        // Present the detail view controller
        viewController?.navigationController?.pushViewController(todoDetailVC, animated: true)
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
