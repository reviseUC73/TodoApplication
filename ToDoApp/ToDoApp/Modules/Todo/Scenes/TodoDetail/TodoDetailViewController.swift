//
//  TodoDetailViewController.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var todo: Todo?
    
    // MARK: - UI Components
    private let backgroundView = GradientBackgroundView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusCheckmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let datesView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let createdDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Created:"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let updatedDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Updated:"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let updatedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Due Date:"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .label
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var markCompletedButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleCompletionStatus), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteTodoTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Add background
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundView)
        
        // Setup navigation bar
        title = "Todo Details"
        navigationController?.navigationBar.tintColor = .darkGray
        
        // Add content
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add UI components to content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryView)
        categoryView.addSubview(categoryLabel)
        contentView.addSubview(statusView)
        statusView.addSubview(statusLabel)
        statusView.addSubview(statusCheckmarkImageView)
        contentView.addSubview(datesView)
        datesView.addSubview(createdDateTitleLabel)
        datesView.addSubview(createdDateLabel)
        datesView.addSubview(updatedDateTitleLabel)
        datesView.addSubview(updatedDateLabel)
        datesView.addSubview(dueDateTitleLabel)
        datesView.addSubview(dueDateLabel)
        contentView.addSubview(descriptionHeaderLabel)
        contentView.addSubview(descriptionView)
        descriptionView.addSubview(descriptionTextView)
        contentView.addSubview(markCompletedButton)
        contentView.addSubview(deleteButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            categoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryView.heightAnchor.constraint(equalToConstant: 24),
            
            categoryLabel.topAnchor.constraint(equalTo: categoryView.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: -10),
            
            statusView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 20),
            statusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusView.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 16),
            
            statusCheckmarkImageView.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            statusCheckmarkImageView.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -16),
            statusCheckmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            statusCheckmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            
            datesView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 20),
            datesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            createdDateTitleLabel.topAnchor.constraint(equalTo: datesView.topAnchor, constant: 16),
            createdDateTitleLabel.leadingAnchor.constraint(equalTo: datesView.leadingAnchor, constant: 16),
            createdDateTitleLabel.widthAnchor.constraint(equalToConstant: 70),
            
            createdDateLabel.topAnchor.constraint(equalTo: createdDateTitleLabel.topAnchor),
            createdDateLabel.leadingAnchor.constraint(equalTo: createdDateTitleLabel.trailingAnchor, constant: 8),
            createdDateLabel.trailingAnchor.constraint(equalTo: datesView.trailingAnchor, constant: -16),
            
            updatedDateTitleLabel.topAnchor.constraint(equalTo: createdDateTitleLabel.bottomAnchor, constant: 12),
            updatedDateTitleLabel.leadingAnchor.constraint(equalTo: datesView.leadingAnchor, constant: 16),
            updatedDateTitleLabel.widthAnchor.constraint(equalToConstant: 70),
            
            updatedDateLabel.topAnchor.constraint(equalTo: updatedDateTitleLabel.topAnchor),
            updatedDateLabel.leadingAnchor.constraint(equalTo: updatedDateTitleLabel.trailingAnchor, constant: 8),
            updatedDateLabel.trailingAnchor.constraint(equalTo: datesView.trailingAnchor, constant: -16),
            
            dueDateTitleLabel.topAnchor.constraint(equalTo: updatedDateTitleLabel.bottomAnchor, constant: 12),
            dueDateTitleLabel.leadingAnchor.constraint(equalTo: datesView.leadingAnchor, constant: 16),
            dueDateTitleLabel.widthAnchor.constraint(equalToConstant: 70),
            dueDateTitleLabel.bottomAnchor.constraint(equalTo: datesView.bottomAnchor, constant: -16),
            
            dueDateLabel.topAnchor.constraint(equalTo: dueDateTitleLabel.topAnchor),
            dueDateLabel.leadingAnchor.constraint(equalTo: dueDateTitleLabel.trailingAnchor, constant: 8),
            dueDateLabel.trailingAnchor.constraint(equalTo: datesView.trailingAnchor, constant: -16),
            
            descriptionHeaderLabel.topAnchor.constraint(equalTo: datesView.bottomAnchor, constant: 24),
            descriptionHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            descriptionView.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor, constant: 12),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 8),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -8),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -8),
            
            markCompletedButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 24),
            markCompletedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            markCompletedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            markCompletedButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: markCompletedButton.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Public Methods
    func configure(with todo: Todo) {
        self.todo = todo
        if isViewLoaded {
            updateUI()
        }
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        guard let todo = todo else { return }
        
        titleLabel.text = todo.title
        categoryLabel.text = todo.category.rawValue
        descriptionTextView.text = todo.description
        
        // Set category color
        switch todo.category {
        case .work:
            categoryView.backgroundColor = UIColor.systemBlue
        case .personal:
            categoryView.backgroundColor = UIColor.systemPurple
        case .shopping:
            categoryView.backgroundColor = UIColor.systemGreen
        case .health:
            categoryView.backgroundColor = UIColor.systemRed
        case .education:
            categoryView.backgroundColor = UIColor.systemOrange
        case .finance:
            categoryView.backgroundColor = UIColor.systemTeal
        case .other:
            categoryView.backgroundColor = UIColor.systemGray
        }
        
        // Set completion status
        statusLabel.text = todo.isCompleted ? "Completed" : "Not Completed"
        statusLabel.textColor = todo.isCompleted ? .systemGreen : .systemBlue
        statusCheckmarkImageView.image = todo.isCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        
        // Set button title
        markCompletedButton.setTitle(todo.isCompleted ? "Mark as Not Completed" : "Mark as Completed", for: .normal)
        
        // Format dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        createdDateLabel.text = dateFormatter.string(from: todo.createdAt)
        updatedDateLabel.text = dateFormatter.string(from: todo.updatedAt)
        
        if let dueDate = todo.dueDate {
            dueDateLabel.text = dateFormatter.string(from: dueDate)
        } else {
            dueDateLabel.text = "No deadline"
        }
    }
    
    // MARK: - Actions
    @objc private func toggleCompletionStatus() {
        guard let todo = todo else { return }
        
        // Create a loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        markCompletedButton.setTitle("", for: .normal)
        markCompletedButton.addSubview(activityIndicator)
        activityIndicator.center = markCompletedButton.center
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: markCompletedButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: markCompletedButton.centerYAnchor)
        ])
        
        // Call API to toggle completion status
        let apiClient = APIClient.shared
        let endpoint = TodoEndpoint.updateTodo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            category: todo.category.rawValue,
            dueDate: todo.dueDate,
            isCompleted: !todo.isCompleted
        )
        
        apiClient.request(endpoint: endpoint) { [weak self] (result: Result<TodoResponse, APIError>) in
            // Ensure UI updates are on the main thread
            DispatchQueue.main.async {
                // Remove activity indicator
                activityIndicator.removeFromSuperview()
                
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    // Update the local todo
                    self.todo = Todo(from: response)
                    self.updateUI()
                    
                    // Show success toast
                    self.showToast(message: "Status updated successfully")
                    
                    // Post notification for todo list to refresh
                    NotificationCenter.default.post(name: NSNotification.Name("TodoCreated"), object: nil)
                    
                case .failure(let error):
                    // Show error toast
                    self.showToast(message: "Failed to update: \(error.localizedDescription)")
                    // Reset button state
                    self.markCompletedButton.setTitle(todo.isCompleted ? "Mark as Not Completed" : "Mark as Completed", for: .normal)
                }
            }
        }
    }
    
    @objc private func deleteTodoTapped() {
        guard let todo = todo else { return }
        
        let alertController = UIAlertController(
            title: "Delete Todo",
            message: "Are you sure you want to delete this todo?",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // Show loading
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.startAnimating()
            activityIndicator.color = .white
            self.deleteButton.setTitle("", for: .normal)
            self.deleteButton.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: self.deleteButton.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: self.deleteButton.centerYAnchor)
            ])
            
            // Call API to delete
            let apiClient = APIClient.shared
            let endpoint = TodoEndpoint.deleteTodo(id: todo.id)
            
            apiClient.request(endpoint: endpoint) { [weak self] (result: Result<MessageResponse, APIError>) in
                DispatchQueue.main.async {
                    activityIndicator.removeFromSuperview()
                    
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(_):
                        // Show success toast
                        self.showToast(message: "Todo deleted successfully")
                        
                        // Post notification for todo list to refresh
                        NotificationCenter.default.post(name: NSNotification.Name("TodoCreated"), object: nil)
                        
                        // Go back to the list
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    case .failure(let error):
                        // Show error toast
                        self.showToast(message: "Failed to delete: \(error.localizedDescription)")
                        self.deleteButton.setTitle("Delete", for: .normal)
                    }
                }
            }
        })
        
        present(alertController, animated: true)
    }
    
    private func showToast(message: String) {
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
        
        view.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            toastLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -40),
            toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
        // Add padding
        toastLabel.layoutIfNeeded()
        let padding: CGFloat = 20
        toastLabel.frame.size.width += padding
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
} 
