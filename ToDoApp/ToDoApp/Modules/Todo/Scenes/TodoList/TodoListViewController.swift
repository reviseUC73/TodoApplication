//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 18/4/2568 BE.
//
import UIKit

protocol TodoListDisplayLogic: AnyObject {
    func displayTodos(viewModel: TodoList.FetchTodos.ViewModel)
    func displayAddedTodo(viewModel: TodoList.AddTodo.ViewModel)
    func displayToggledTodoStatus(viewModel: TodoList.ToggleTodoStatus.ViewModel)
    func displayDeletedTodo(viewModel: TodoList.DeleteTodo.ViewModel)
}

class TodoListViewController: UIViewController, TodoListDisplayLogic {
    
    // MARK: - Section Model
    enum Section {
        case inProgress
        case completed
        
        var title: String {
            switch self {
            case .inProgress:
                return "In Progress"
            case .completed:
                return "Completed"
            }
        }
    }
    
    // MARK: - Clean Swift
    var interactor: TodoListBusinessLogic?
    var router: (NSObjectProtocol & TodoListRoutingLogic & TodoListDataPassing)?
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "list.bullet.clipboard"))
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "No todos yet. Tap '+' to add one."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        return view
    }()
    
    // MARK: - Properties
    private var displayedTodos: [TodoList.FetchTodos.ViewModel.DisplayedTodo] = []
    private var sections: [Section] = [.inProgress, .completed]
    
    // Grouped todos
    private var inProgressTodos: [TodoList.FetchTodos.ViewModel.DisplayedTodo] {
        return displayedTodos.filter { !$0.isCompleted }
    }
    
    private var completedTodos: [TodoList.FetchTodos.ViewModel.DisplayedTodo] {
        return displayedTodos.filter { $0.isCompleted }
    }
    
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = TodoListInteractor()
        let presenter = TodoListPresenter()
        let router = TodoListRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTodos()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Todo List"
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyStateView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add a refresh button
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshButtonTapped)
        )
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        router?.routeToAddTodo()
    }
    
    @objc private func refreshButtonTapped() {
        fetchTodos()
    }
    
    // MARK: - Business Logic
    private func fetchTodos() {
        let request = TodoList.FetchTodos.Request()
        interactor?.fetchTodos(request: request)
    }
    
    // Get todos for a specific section
    private func todos(for section: Section) -> [TodoList.FetchTodos.ViewModel.DisplayedTodo] {
         switch section {
         case .inProgress:
             return inProgressTodos
         case .completed:
             return completedTodos
         }
     }
    
    // MARK: - Helpers
    private func showToast(message: String) {
        DispatchQueue.main.async {
            let toastLabel = UILabel()
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            toastLabel.textColor = .white
            toastLabel.textAlignment = .center
            toastLabel.font = UIFont.systemFont(ofSize: 14)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(toastLabel)
            
            NSLayoutConstraint.activate([
                toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                toastLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
                toastLabel.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, constant: -40),
                toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
            ])
            
            // Add padding
            toastLabel.layoutIfNeeded()
            let padding: CGFloat = 20
            toastLabel.frame.size.width += padding
            
            UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
}

// MARK: - Display Logic
extension TodoListViewController {
    func displayTodos(viewModel: TodoList.FetchTodos.ViewModel) {
        displayedTodos = viewModel.displayedTodos
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.emptyStateView.isHidden = !self.displayedTodos.isEmpty
            self.tableView.reloadData()
        }
    }
    
    func displayAddedTodo(viewModel: TodoList.AddTodo.ViewModel) {
        showToast(message: viewModel.message)
    }
    
    func displayToggledTodoStatus(viewModel: TodoList.ToggleTodoStatus.ViewModel) {
        showToast(message: viewModel.message)
    }
    
    func displayDeletedTodo(viewModel: TodoList.DeleteTodo.ViewModel) {
        showToast(message: viewModel.message)
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !displayedTodos.isEmpty else { return nil }
        
        let currentSection = sections[section]
        let sectionTodos = todos(for: currentSection)
        
        // Only show section header if there are todos in this section
        if sectionTodos.isEmpty {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.text = currentSection.title
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard !displayedTodos.isEmpty else { return 0 }
        
        let currentSection = sections[section]
        let sectionTodos = todos(for: currentSection)
        
        // Return 0 height if section is empty
        return sectionTodos.isEmpty ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            
            let todoId = self.displayedTodos[indexPath.row].id
            let request = TodoList.DeleteTodo.Request(id: todoId)
            self.interactor?.deleteTodo(request: request)
            
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


// MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return displayedTodos.count
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        return todos(for: currentSection).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let currentSection = sections[indexPath.section]
        let sectionTodos = todos(for: currentSection)
//        let todo = displayedTodos[indexPath.row]
        let todo = sectionTodos[indexPath.row]
        
        // Configure cell with the todo data
        cell.configure(with: todo)
        
        // Set self as the delegate for the cell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - TodoTableViewCellDelegate
extension TodoListViewController: TodoTableViewCellDelegate {
    func todoTableViewCell(_ cell: TodoTableViewCell, didToggleCompletionStatus isCompleted: Bool, forTodoWithId id: String) {
        // Create request to toggle todo status
        let request = TodoList.ToggleTodoStatus.Request(
            id: id,
            isCompleted: !isCompleted
        )
        
        // Call interactor to update the todo status
        interactor?.toggleTodoStatus(request: request)
    }
}

