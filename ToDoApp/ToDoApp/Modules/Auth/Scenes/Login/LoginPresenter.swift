//
//  LoginPresenter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol LoginPresentationLogic {
    func presentLogin(response: Login.Login.Response)
}

class LoginPresenter: LoginPresentationLogic {
    weak var viewController: LoginDisplayLogic?
    
    func presentLogin(response: Login.Login.Response) {
        let viewModel = Login.Login.ViewModel(
            success: response.success,
            errorMessage: response.errorMessage
        )
        
        viewController?.displayLogin(viewModel: viewModel)
    }
}
