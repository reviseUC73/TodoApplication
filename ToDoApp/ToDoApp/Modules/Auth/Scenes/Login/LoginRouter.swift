//
//  LoginRouter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

@objc protocol LoginRoutingLogic {
    func routeToTodoList()
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing {
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    // MARK: - Routing
    
    func routeToTodoList() {
        // Navigate to TodoList scene
        AppRouter.shared.navigateToTodoList()
    }
}
