//
//  SwipeableTodoCardView.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 20/4/2568 BE.
//

import UIKit

protocol SwipeableTodoCardViewDelegate: AnyObject {
    func swipeableTodoCardView(_ cardView: SwipeableTodoCardView, didSwipeToDeleteTodoWithId id: String)
    func swipeableTodoCardView(_ cardView: SwipeableTodoCardView, didToggleCompletionStatus isCompleted: Bool, forTodoWithId id: String)
    func swipeableTodoCardViewDidLongPress(_ cardView: SwipeableTodoCardView, forTodoWithId id: String)
}

class SwipeableTodoCardView: UIView {
    
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
    
    private let todoCardView: TodoCardView = {
        let cardView = TodoCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private let deleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trash")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var todoId: String = ""
    private var isCompleted: Bool = false
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var originalCenter: CGPoint = .zero
    private var deleteOnDragRelease = false
    private weak var delegate: SwipeableTodoCardViewDelegate?
    
    // Constants for swipe behavior
    private let deleteThreshold: CGFloat = 75.0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGestures()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        // Add delete view first (will be behind the container)
        addSubview(deleteView)
        deleteView.addSubview(deleteImageView)
        deleteView.addSubview(deleteLabel)
        
        // Add container with todo card
        addSubview(containerView)
        containerView.addSubview(todoCardView)
        
        NSLayoutConstraint.activate([
            // Container constraints
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // TodoCardView constraints (fill container)
            todoCardView.topAnchor.constraint(equalTo: containerView.topAnchor),
            todoCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            todoCardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            todoCardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Delete view constraints
            deleteView.topAnchor.constraint(equalTo: topAnchor),
            deleteView.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            deleteView.widthAnchor.constraint(equalToConstant: 100),
            
            // Delete icon constraints
            deleteImageView.centerYAnchor.constraint(equalTo: deleteView.centerYAnchor),
            deleteImageView.centerXAnchor.constraint(equalTo: deleteView.centerXAnchor, constant: -20),
            deleteImageView.widthAnchor.constraint(equalToConstant: 20),
            deleteImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Delete label constraints
            deleteLabel.centerYAnchor.constraint(equalTo: deleteView.centerYAnchor),
            deleteLabel.leadingAnchor.constraint(equalTo: deleteImageView.trailingAnchor, constant: 8)
        ])
    }
    
    private func setupGestures() {
        // Pan gesture for swiping
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        containerView.addGestureRecognizer(panGestureRecognizer)
        
        // Tap gesture for toggling completion
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        containerView.addGestureRecognizer(tapGesture)
        
        // Long press gesture for additional options
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cardLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0.5
        containerView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Gesture Handlers
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            originalCenter = containerView.center
        
        case .changed:
            // Only allow swipe to the left (negative x translation)
            if translation.x <= 0 {
                containerView.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
                
                // Update state based on translation
                deleteOnDragRelease = containerView.frame.origin.x < -deleteThreshold
                
                // Show/hide delete view based on swipe distance
                deleteView.alpha = min(1.0, abs(translation.x) / deleteThreshold)
            }
            
        case .ended:
            if deleteOnDragRelease {
                // Animate off screen then call delegate
                UIView.animate(withDuration: 0.1, animations: {
                    self.containerView.center = CGPoint(x: -self.containerView.bounds.width, y: self.originalCenter.y)
                }) { _ in
                    self.delegate?.swipeableTodoCardView(self, didSwipeToDeleteTodoWithId: self.todoId)
                }
            } else {
                // Animate back to original position
                UIView.animate(withDuration: 0.1) {
                    self.containerView.center = self.originalCenter
                    self.deleteView.alpha = 0
                }
            }
            
        default:
            // Reset to original position for any other state
            UIView.animate(withDuration: 0.1) {
                self.containerView.center = self.originalCenter
                self.deleteView.alpha = 0
            }
        }
    }
    
    @objc private func cardTapped() {
        delegate?.swipeableTodoCardView(self, didToggleCompletionStatus: isCompleted, forTodoWithId: todoId)
    }
    
    @objc private func cardLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.swipeableTodoCardViewDidLongPress(self, forTodoWithId: todoId)
        }
    }
    
    // MARK: - Configuration
    func configure(with todo: TodoList.FetchTodos.ViewModel.DisplayedTodo, delegate: SwipeableTodoCardViewDelegate) {
        self.todoId = todo.id
        self.isCompleted = todo.isCompleted
        self.delegate = delegate
        
        // Configure the inner TodoCardView
        todoCardView.configure(with: todo, delegate: self)
        
        // Reset position
        deleteView.alpha = 0
        containerView.frame.origin.x = 0
    }
}

// MARK: - TodoCardViewDelegate
extension SwipeableTodoCardView: TodoCardViewDelegate {
    func todoCardView(_ cardView: TodoCardView, didToggleCompletionStatus isCompleted: Bool, forTodoWithId id: String) {
        delegate?.swipeableTodoCardView(self, didToggleCompletionStatus: isCompleted, forTodoWithId: id)
    }
    
    func todoCardViewDidLongPress(_ cardView: TodoCardView, forTodoWithId id: String) {
        delegate?.swipeableTodoCardViewDidLongPress(self, forTodoWithId: id)
    }
}
