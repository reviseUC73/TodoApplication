//
//  TodoListInteractor.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol TodoListBusinessLogic {
    func fetchTodos(request: TodoList.FetchTodos.Request)
    func addTodo(request: TodoList.AddTodo.Request)
    func toggleTodoStatus(request: TodoList.ToggleTodoStatus.Request)
    func deleteTodo(request: TodoList.DeleteTodo.Request)
}

protocol TodoListDataStore {
    var todos: [Todo] { get }
}

class TodoListInteractor: TodoListBusinessLogic, TodoListDataStore {
    var presenter: TodoListPresentationLogic?
    var worker: TodoListWorkerProtocol
    var todos: [Todo] = []
    
    init(worker: TodoListWorkerProtocol = TodoListWorker()) {
        self.worker = worker
    }
    
    func fetchTodos(request: TodoList.FetchTodos.Request) {
        worker.fetchTodos(ignoreCache: request.ignoreCache) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let todos):
                self.todos = todos
                let response = TodoList.FetchTodos.Response(todos: todos)
                self.presenter?.presentTodos(response: response)
            case .failure(let error):
                // Handle error presentation via presenter
                print("Error fetching todos: \(error)")
            }
        }
    }
    
    func addTodo(request: TodoList.AddTodo.Request) {
        worker.createTodo(
            title: request.title,
            description: request.description,
            category: request.category,
            dueDate: request.dueDate
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let todo):
                self.todos.append(todo)
                let response = TodoList.AddTodo.Response(todo: todo)
                self.presenter?.presentAddedTodo(response: response)
                
                // Refresh the todo list
                self.fetchTodos(request: TodoList.FetchTodos.Request())
            case .failure(let error):
                // Handle error presentation via presenter
                print("Error adding todo: \(error)")
            }
        }
    }
    
    func toggleTodoStatus(request: TodoList.ToggleTodoStatus.Request) {
        guard let todo = todos.first(where: { $0.id == request.id }) else { return }
        
        worker.updateTodo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            category: todo.category,
            dueDate: todo.dueDate,
            isCompleted: request.isCompleted
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let updatedTodo):
                if let index = self.todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                    self.todos[index] = updatedTodo
                }
                
                let response = TodoList.ToggleTodoStatus.Response(todo: updatedTodo)
                self.presenter?.presentToggledTodoStatus(response: response)
                
                // Refresh the todo list
                self.fetchTodos(request: TodoList.FetchTodos.Request())
            case .failure(let error):
                // Handle error presentation via presenter
                print("Error toggling todo status: \(error)")
            }
        }
    }
    
    func deleteTodo(request: TodoList.DeleteTodo.Request) {
        worker.deleteTodo(id: request.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                if let index = self.todos.firstIndex(where: { $0.id == request.id }) {
                    self.todos.remove(at: index)
                }
                
                let response = TodoList.DeleteTodo.Response(success: true)
                self.presenter?.presentDeletedTodo(response: response)
                
                // Refresh the todo list
                self.fetchTodos(request: TodoList.FetchTodos.Request())
            case .failure(let error):
                // Handle error presentation via presenter
                print("Error deleting todo: \(error)")
            }
        }
    }
}
