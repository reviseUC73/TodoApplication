//
//  RegisterRouter.swift .swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//

import UIKit

@objc protocol RegisterRoutingLogic {
    func routeToLogin()
}

protocol RegisterDataPassing {
    var dataStore: RegisterDataStore? { get }
}

class RegisterRouter: NSObject, RegisterRoutingLogic, RegisterDataPassing {
    weak var viewController: RegisterViewController?
    var dataStore: RegisterDataStore?
    
    // MARK: - Routing
    
    func routeToLogin() {
        // Navigate to login screen
        AppRouter.shared.navigateToLogin()
    }
}
