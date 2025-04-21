//
//  TodoDetailInteractor.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import Foundation

protocol TodoDetailBusinessLogic {
    func fetchTodoDetail(request: TodoDetail.FetchTodoDetail.Request)
    func toggleTodoStatus(request: TodoDetail.ToggleTodoStatus.Request)
    func deleteTodo(request: TodoDetail.DeleteTodo.Request)
}

protocol TodoDetailDataStore {
    var todo: Todo? { get set }
}

class TodoDetailInteractor: TodoDetailBusinessLogic, TodoDetailDataStore {
    var presenter: TodoDetailPresentationLogic?
    var worker: TodoDetailWorkerLogic
    var todo: Todo?
    
    init(worker: TodoDetailWorkerLogic = TodoDetailWorker()) {
        self.worker = worker
    }
    
    func fetchTodoDetail(request: TodoDetail.FetchTodoDetail.Request) {
        if let existingTodo = todo, existingTodo.id == request.id {
            let response = TodoDetail.FetchTodoDetail.Response(todo: existingTodo)
            presenter?.presentTodoDetail(response: response)
            return
        }
        
        worker.fetchTodoDetail(id: request.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let todo):
                self.todo = todo
                let response = TodoDetail.FetchTodoDetail.Response(todo: todo)
                self.presenter?.presentTodoDetail(response: response)
                
            case .failure(let error):
                print("Error fetching todo detail: \(error)")
                // Handle error presentation
            }
        }
    }
    
    func toggleTodoStatus(request: TodoDetail.ToggleTodoStatus.Request) {
        guard let todo = todo else { return }
        
        worker.updateTodoStatus(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            category: todo.category.rawValue,
            dueDate: todo.dueDate,
            isCompleted: request.isCompleted
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let updatedTodo):
                self.todo = updatedTodo
                let response = TodoDetail.ToggleTodoStatus.Response(
                    todo: updatedTodo,
                    success: true,
                    errorMessage: nil
                )
                self.presenter?.presentToggledTodoStatus(response: response)
                
            case .failure(let error):
                print("Error toggling todo status: \(error)")
                let response = TodoDetail.ToggleTodoStatus.Response(
                    todo: todo,
                    success: false,
                    errorMessage: error.localizedDescription
                )
                self.presenter?.presentToggledTodoStatus(response: response)
            }
        }
    }
    
    func deleteTodo(request: TodoDetail.DeleteTodo.Request) {
        worker.deleteTodo(id: request.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let response = TodoDetail.DeleteTodo.Response(
                    success: true,
                    errorMessage: nil
                )
                self.presenter?.presentDeletedTodo(response: response)
                
            case .failure(let error):
                print("Error deleting todo: \(error)")
                let response = TodoDetail.DeleteTodo.Response(
                    success: false, 
                    errorMessage: error.localizedDescription
                )
                self.presenter?.presentDeletedTodo(response: response)
            }
        }
    }
}
