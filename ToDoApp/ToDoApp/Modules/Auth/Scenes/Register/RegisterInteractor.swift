//
//  RegisterInteractor.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//

import Foundation

protocol RegisterBusinessLogic {
    func register(request: Register.Register.Request)
}

protocol RegisterDataStore {
    var username: String? { get }
    var email: String? { get }
}

class RegisterInteractor: RegisterBusinessLogic, RegisterDataStore {
    var presenter: RegisterPresentationLogic?
    var worker: RegisterWorkerProtocol
    
    // MARK: - DataStore
    var username: String?
    var email: String?
    
    init(worker: RegisterWorkerProtocol = RegisterWorker()) {
        self.worker = worker
    }
    
    func register(request: Register.Register.Request) {
        // Store data in data store
        self.username = request.username
        self.email = request.email
        
        worker.register(username: request.username, email: request.email, password: request.password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                let response = Register.Register.Response(success: true, errorMessage: nil)
                self.presenter?.presentRegistration(response: response)
            case .failure(let error):
                let response = Register.Register.Response(success: false, errorMessage: error.localizedDescription)
                self.presenter?.presentRegistration(response: response)
            }
        }
    }
}
