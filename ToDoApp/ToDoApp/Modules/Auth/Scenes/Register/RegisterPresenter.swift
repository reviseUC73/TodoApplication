//
//  RegisterPresenter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//


import Foundation

protocol RegisterPresentationLogic {
    func presentRegistration(response: Register.Register.Response)
}

class RegisterPresenter: RegisterPresentationLogic {
    weak var viewController: RegisterDisplayLogic?
    
    func presentRegistration(response: Register.Register.Response) {
        let viewModel = Register.Register.ViewModel(
            success: response.success,
            errorMessage: response.errorMessage
        )
        
        viewController?.displayRegistration(viewModel: viewModel)
    }
}
