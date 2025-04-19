//
//  AddTodoPresenter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol AddTodoPresentationLogic {
    func presentCreatedTodo(response: AddTodo.Create.Response)
    func presentCategories(response: AddTodo.FetchCategories.Response)
}

class AddTodoPresenter: AddTodoPresentationLogic {
    weak var viewController: AddTodoDisplayLogic?
    
    func presentCreatedTodo(response: AddTodo.Create.Response) {
        let viewModel = AddTodo.Create.ViewModel(
            success: response.success,
            errorMessage: response.error?.localizedDescription
        )
        
        viewController?.displayCreatedTodo(viewModel: viewModel)
    }
    
    func presentCategories(response: AddTodo.FetchCategories.Response) {
        let categoryNames = response.categories.map { $0.rawValue }
        let viewModel = AddTodo.FetchCategories.ViewModel(categories: categoryNames)
        
        viewController?.displayCategories(viewModel: viewModel)
    }
}
