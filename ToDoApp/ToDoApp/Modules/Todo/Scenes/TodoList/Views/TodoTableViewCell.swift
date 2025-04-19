//
//  TodoTableViewCell.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
    func todoTableViewCell(_ cell: TodoTableViewCell, didToggleCompletionStatus isCompleted: Bool, forTodoWithId id: String)
}

class TodoTableViewCell: UITableViewCell {
    static let identifier = "TodoTableViewCell"
    
    // MARK: - Properties
    
    weak var delegate: TodoTableViewCellDelegate?
    private var todoId: String = ""
    private var isCompleted = false
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBlue
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let updatedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        todoId = ""
        isCompleted = false
        titleLabel.attributedText = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        categoryLabel.text = nil
        dueDateLabel.text = nil
        updatedDateLabel.text = nil
        statusButton.setImage(UIImage(systemName: "circle"), for: .normal)
        
        // Hide date elements by default
        dueDateImageView.isHidden = true
        dueDateLabel.isHidden = true
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(statusButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(dueDateImageView)
        containerView.addSubview(dueDateLabel)
        containerView.addSubview(updatedDateLabel)
        
        // Hide date elements by default
        dueDateImageView.isHidden = true
        dueDateLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            statusButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            statusButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusButton.widthAnchor.constraint(equalToConstant: 24),
            statusButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 12),
//            titleLabel.trailingAnchor.constraint(equalTo: categoryLabel.leadingAnchor, constant: -8),
            
            categoryLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            categoryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            categoryLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            dueDateImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            dueDateImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dueDateImageView.widthAnchor.constraint(equalToConstant: 14),
            dueDateImageView.heightAnchor.constraint(equalToConstant: 14),
            
            dueDateLabel.centerYAnchor.constraint(equalTo: dueDateImageView.centerYAnchor),
            dueDateLabel.leadingAnchor.constraint(equalTo: dueDateImageView.trailingAnchor, constant: 4),
            
            updatedDateLabel.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 4),
            updatedDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            updatedDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            updatedDateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        // Add status button action
        statusButton.addTarget(self, action: #selector(statusButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func statusButtonTapped() {
        delegate?.todoTableViewCell(self, didToggleCompletionStatus: isCompleted, forTodoWithId: todoId)
    }
    
    // MARK: - Configuration
    
    func configure(with todo: TodoList.FetchTodos.ViewModel.DisplayedTodo) {
        todoId = todo.id
        isCompleted = todo.isCompleted
        
        // Set category
        categoryLabel.text = todo.category.rawValue
        
        // Set basic text content
        descriptionLabel.text = todo.description
        updatedDateLabel.text = "Updated: \(todo.formattedDate)"
        
        // Set due date if available
        if let formattedDueDate = todo.formattedDueDate, !formattedDueDate.isEmpty {
            dueDateImageView.isHidden = false
            dueDateLabel.isHidden = false
            dueDateLabel.text = formattedDueDate
        } else {
            dueDateImageView.isHidden = true
            dueDateLabel.isHidden = true
        }
        
        // Update status button appearance
        let imageName = todo.isCompleted ? "checkmark.circle.fill" : "circle"
        statusButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        // Apply strikethrough to title if completed
        if todo.isCompleted {
            let attributedString = NSAttributedString(
                string: todo.title,
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = todo.title
        }
        
        // Set category color based on category type
        switch todo.category {
        case .work:
            categoryLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
            categoryLabel.textColor = .systemBlue
        case .personal:
            categoryLabel.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.2)
            categoryLabel.textColor = .systemPurple
        case .shopping:
            categoryLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            categoryLabel.textColor = .systemGreen
        case .health:
            categoryLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            categoryLabel.textColor = .systemRed
        case .education:
            categoryLabel.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
            categoryLabel.textColor = .systemOrange
        case .finance:
            categoryLabel.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.2)
            categoryLabel.textColor = .systemTeal
        case .other:
            categoryLabel.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            categoryLabel.textColor = .systemGray
        }
        
        // Add padding to category label
        categoryLabel.layer.cornerRadius = 4
        categoryLabel.clipsToBounds = true
        let paddingInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        categoryLabel.frame = categoryLabel.frame.inset(by: paddingInsets)
    }
}
