//
//  AddTodoInteractor.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol AddTodoBusinessLogic {
    func createTodo(request: AddTodo.Create.Request)
    func fetchCategories(request: AddTodo.FetchCategories.Request)
}

protocol AddTodoDataStore {
    var title: String? { get set }
    var taskDescription: String? { get set }
    var category: TodoCategory? { get set }
    var dueDate: Date? { get set }
}

class AddTodoInteractor: AddTodoBusinessLogic, AddTodoDataStore {
    var presenter: AddTodoPresentationLogic?
    var worker: AddTodoWorkerProtocol
    
    // MARK: - DataStore
    var title: String?
    var taskDescription: String?
    var category: TodoCategory?
    var dueDate: Date?
    
    init(worker: AddTodoWorkerProtocol = AddTodoWorker()) {
        self.worker = worker
    }
    
    func createTodo(request: AddTodo.Create.Request) {
        // Store values in data store
        self.title = request.title
        self.taskDescription = request.description
        self.category = request.category
        self.dueDate = request.dueDate
        
        worker.createTodo(
            title: request.title,
            description: request.description,
            category: request.category,
            dueDate: request.dueDate
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                let response = AddTodo.Create.Response(success: true, error: nil)
                self.presenter?.presentCreatedTodo(response: response)
            case .failure(let error):
                let response = AddTodo.Create.Response(success: false, error: error)
                self.presenter?.presentCreatedTodo(response: response)
            }
        }
    }
    
    func fetchCategories(request: AddTodo.FetchCategories.Request) {
        worker.fetchCategories { [weak self] categories in
            guard let self = self else { return }
            
            let response = AddTodo.FetchCategories.Response(categories: categories)
            self.presenter?.presentCategories(response: response)
        }
    }
}
