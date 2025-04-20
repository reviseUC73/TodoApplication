//
//  AddTodoRouter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol AddTodoRoutingLogic {
    func routeToTodoList()
}

protocol AddTodoDataPassing {
    var dataStore: AddTodoDataStore? { get }
}

class AddTodoRouter: NSObject, AddTodoRoutingLogic, AddTodoDataPassing {
    weak var viewController: AddTodoViewController?
    var dataStore: AddTodoDataStore?
    
    // MARK: - Routing
    
    func routeToTodoList() {
        // Make sure UI operations are performed on the main thread
        DispatchQueue.main.async { [weak self] in
            // Simply dismiss this view controller to go back to the TodoList
            self?.viewController?.dismiss(animated: true)
        }
    }
}
