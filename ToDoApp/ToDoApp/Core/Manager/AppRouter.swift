//
//  AppRouter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol AppRouterProtocol {
    func start(window: UIWindow)
    func navigateToTodoList()
    func navigateToLogin()
}

class AppRouter: AppRouterProtocol {
    static let shared = AppRouter()
    
    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    private init() {}
    
    func start(window: UIWindow) {
        self.window = window
        
        // Check if user is logged in - simplified for demo
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            navigateToTodoList()
        } else {
            navigateToLogin()
        }
        
        window.makeKeyAndVisible()
    }
    
    func navigateToTodoList() {
        let todoListVC = TodoListViewController()
        let nav = UINavigationController(rootViewController: todoListVC)
        self.navigationController = nav
        window?.rootViewController = nav
    }
    
    func navigateToLogin() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        self.navigationController = nav
        window?.rootViewController = nav
    }
    
    func navigateToRegister() {
        let registerVC = RegisterViewController()
        let nav = UINavigationController(rootViewController: registerVC)
        self.navigationController = nav
        window?.rootViewController = nav
    }
}
