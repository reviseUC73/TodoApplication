//
//  LoginInteractor.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol LoginBusinessLogic {
    func login(request: Login.Login.Request)
}

protocol LoginDataStore {
    // Add any shared data here if needed
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    var presenter: LoginPresentationLogic?
    var worker: LoginWorkerProtocol
    
    init(worker: LoginWorkerProtocol = LoginWorker()) {
        self.worker = worker
    }
    
    func login(request: Login.Login.Request) {
        worker.login(username: request.username, password: request.password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                let response = Login.Login.Response(success: true, errorMessage: nil)
                self.presenter?.presentLogin(response: response)
            case .failure(let error):
                let response = Login.Login.Response(success: false, errorMessage: error.localizedDescription)
                self.presenter?.presentLogin(response: response)
            }
        }
    }
}
