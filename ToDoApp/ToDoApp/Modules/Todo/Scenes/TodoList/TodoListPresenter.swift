//
//  TodoListPresenter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import Foundation

protocol TodoListPresentationLogic {
    func presentTodos(response: TodoList.FetchTodos.Response)
    func presentAddedTodo(response: TodoList.AddTodo.Response)
    func presentToggledTodoStatus(response: TodoList.ToggleTodoStatus.Response)
    func presentDeletedTodo(response: TodoList.DeleteTodo.Response)
}

class TodoListPresenter: TodoListPresentationLogic {
    weak var viewController: TodoListDisplayLogic?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    func presentTodos(response: TodoList.FetchTodos.Response) {
        let displayedTodos = response.todos.map { todo in
            let formattedDueDate = todo.dueDate.map { dueDateFormatter.string(from: $0) }
            
            return TodoList.FetchTodos.ViewModel.DisplayedTodo(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                category: todo.category,
                dueDate: todo.dueDate,
                isCompleted: todo.isCompleted,
                formattedDate: dateFormatter.string(from: todo.updatedAt),
                formattedDueDate: formattedDueDate
            )
        }
        
        let viewModel = TodoList.FetchTodos.ViewModel(displayedTodos: displayedTodos)
        viewController?.displayTodos(viewModel: viewModel)
    }
    
    func presentAddedTodo(response: TodoList.AddTodo.Response) {
        let viewModel = TodoList.AddTodo.ViewModel(message: "Todo added successfully")
        viewController?.displayAddedTodo(viewModel: viewModel)
    }
    
    func presentToggledTodoStatus(response: TodoList.ToggleTodoStatus.Response) {
        let status = response.todo.isCompleted ? "completed" : "pending"
        let viewModel = TodoList.ToggleTodoStatus.ViewModel(message: "Todo marked as \(status)")
        viewController?.displayToggledTodoStatus(viewModel: viewModel)
    }
    
    func presentDeletedTodo(response: TodoList.DeleteTodo.Response) {
        let viewModel = TodoList.DeleteTodo.ViewModel(message: "Todo deleted successfully")
        viewController?.displayDeletedTodo(viewModel: viewModel)
    }
}
