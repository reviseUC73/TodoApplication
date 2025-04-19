//
//  TodoCardView.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol TodoCardViewDelegate: AnyObject {
    func todoCardView(_ cardView: TodoCardView, didToggleCompletionStatus isCompleted: Bool, forTodoWithId id: String)
    func todoCardViewDidLongPress(_ cardView: TodoCardView, forTodoWithId id: String)
}

class TodoCardView: UIView {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dueDateIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var todoId: String = ""
    private var isCompleted: Bool = false
    private weak var delegate: TodoCardViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(statusIndicator)
        statusIndicator.addSubview(statusIcon)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(dueDateContainer)
        dueDateContainer.addSubview(dueDateIcon)
        dueDateContainer.addSubview(dueDateLabel)
        containerView.addSubview(categoryContainer)
        categoryContainer.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            statusIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            statusIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusIndicator.widthAnchor.constraint(equalToConstant: 24),
            statusIndicator.heightAnchor.constraint(equalToConstant: 24),
            
            statusIcon.centerXAnchor.constraint(equalTo: statusIndicator.centerXAnchor),
            statusIcon.centerYAnchor.constraint(equalTo: statusIndicator.centerYAnchor),
            statusIcon.widthAnchor.constraint(equalToConstant: 14),
            statusIcon.heightAnchor.constraint(equalToConstant: 14),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            dueDateContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            dueDateContainer.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dueDateContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            dueDateContainer.heightAnchor.constraint(equalToConstant: 24),
            
            dueDateIcon.leadingAnchor.constraint(equalTo: dueDateContainer.leadingAnchor, constant: 6),
            dueDateIcon.centerYAnchor.constraint(equalTo: dueDateContainer.centerYAnchor),
            dueDateIcon.widthAnchor.constraint(equalToConstant: 12),
            dueDateIcon.heightAnchor.constraint(equalToConstant: 12),
            
            dueDateLabel.leadingAnchor.constraint(equalTo: dueDateIcon.trailingAnchor, constant: 4),
            dueDateLabel.centerYAnchor.constraint(equalTo: dueDateContainer.centerYAnchor),
            dueDateLabel.trailingAnchor.constraint(equalTo: dueDateContainer.trailingAnchor, constant: -6),
            
            categoryContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            categoryContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            categoryContainer.heightAnchor.constraint(equalToConstant: 24),
            
            categoryLabel.topAnchor.constraint(equalTo: categoryContainer.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: categoryContainer.bottomAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor, constant: -8),
        ])
        
        // Add tap gesture to toggle completion status
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        // Add long press gesture for additional options
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cardLongPressed))
        longPressGesture.minimumPressDuration = 0.5
        containerView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Actions
    
    @objc private func cardTapped() {
        delegate?.todoCardView(self, didToggleCompletionStatus: isCompleted, forTodoWithId: todoId)
    }
    
    @objc private func cardLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.todoCardViewDidLongPress(self, forTodoWithId: todoId)
        }
    }
    
    // MARK: - Configuration
    
    func configure(with todo: TodoList.FetchTodos.ViewModel.DisplayedTodo, delegate: TodoCardViewDelegate) {
        self.todoId = todo.id
        self.isCompleted = todo.isCompleted
        self.delegate = delegate
        
        // Set text content
        titleLabel.text = todo.title
        descriptionLabel.text = todo.description
        
        // Configure due date if available
        if let formattedDueDate = todo.formattedDueDate, !formattedDueDate.isEmpty {
            dueDateContainer.isHidden = false
            dueDateLabel.text = formattedDueDate
        } else {
            dueDateContainer.isHidden = true
        }
        
        // Configure category
        categoryLabel.text = todo.category.rawValue
        
        // Apply styling based on completion status
        if todo.isCompleted {
            statusIndicator.backgroundColor = .systemGreen
            statusIcon.image = UIImage(systemName: "checkmark")
            
//           // Apply strikethrough to title if completed
//            let attributedString = NSAttributedString(
//                string: todo.title,
//                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
//            )
//            titleLabel.attributedText = attributedString
        } else {
            statusIndicator.backgroundColor = .systemBlue
            statusIcon.image = nil
            
            // Normal title for incomplete todos
//            titleLabel.attributedText = nil
            titleLabel.text = todo.title
        }
        
        // Set category color based on category type
        switch todo.category {
        case .work:
            categoryContainer.backgroundColor = UIColor.systemBlue
        case .personal:
            categoryContainer.backgroundColor = UIColor.systemPurple
        case .shopping:
            categoryContainer.backgroundColor = UIColor.systemGreen
        case .health:
            categoryContainer.backgroundColor = UIColor.systemRed
        case .education:
            categoryContainer.backgroundColor = UIColor.systemOrange
        case .finance:
            categoryContainer.backgroundColor = UIColor.systemTeal
        case .other:
            categoryContainer.backgroundColor = UIColor.systemGray
        }
    }
}
