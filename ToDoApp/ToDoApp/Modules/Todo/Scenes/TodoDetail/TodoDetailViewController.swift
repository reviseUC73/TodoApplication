//
//  TodoDetailViewController.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import UIKit

protocol TodoDetailDisplayLogic: AnyObject {
    func displayTodoDetail(viewModel: TodoDetail.FetchTodoDetail.ViewModel)
    func displayToggledTodoStatus(viewModel: TodoDetail.ToggleTodoStatus.ViewModel)
    func displayDeletedTodo(viewModel: TodoDetail.DeleteTodo.ViewModel)
}

class TodoDetailViewController: UIViewController, TodoDetailDisplayLogic {
    
    // MARK: - Clean Swift
    var interactor: TodoDetailBusinessLogic?
    var router: (NSObjectProtocol & TodoDetailRoutingLogic & TodoDetailDataPassing)?
    
    // MARK: - Properties
    private var todoId: String?
    private var viewModel: TodoDetail.FetchTodoDetail.ViewModel?
    
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
    
    // MARK: - Object Lifecycle
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
        let interactor = TodoDetailInteractor()
        let presenter = TodoDetailPresenter()
        let router = TodoDetailRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTodoDetail()
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
    
    // ใช้สำหรับรับ todo id จากหน้าอื่น
    func configure(with todo: Todo) {
        guard let router = router, var dataStore = router.dataStore else { return }
        
        dataStore.todo = todo
        todoId = todo.id
        
        // ถ้า view ถูกโหลดแล้ว ให้ดึงข้อมูลใหม่
        if isViewLoaded {
            fetchTodoDetail()
        }
    }
    
    // MARK: - Business Logic
    
    private func fetchTodoDetail() {
        guard let todoId = todoId ?? router?.dataStore?.todo?.id else { return }
        
        let request = TodoDetail.FetchTodoDetail.Request(id: todoId)
        interactor?.fetchTodoDetail(request: request)
    }
    
    // MARK: - Actions
    
    @objc private func toggleCompletionStatus() {
        guard let viewModel = viewModel else { return }
        
        // แสดง loading indicator
        showLoadingIndicator(on: markCompletedButton)
        
        // สร้าง request ในรูปแบบที่ interactor เข้าใจ
        let request = TodoDetail.ToggleTodoStatus.Request(
            id: viewModel.id,
            isCompleted: !viewModel.isCompleted
        )
        
        // เรียกใช้ interactor เพื่อ toggle status
        interactor?.toggleTodoStatus(request: request)
    }
    
    @objc private func deleteTodoTapped() {
        guard let viewModel = viewModel else { return }
        
        let alertController = UIAlertController(
            title: "Delete Todo",
            message: "Are you sure you want to delete this todo?",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // แสดง loading indicator
            self.showLoadingIndicator(on: self.deleteButton)
            
            // สร้าง request และเรียกใช้ interactor
            let request = TodoDetail.DeleteTodo.Request(id: viewModel.id)
            self.interactor?.deleteTodo(request: request)
        })
        
        present(alertController, animated: true)
    }
    
    // MARK: - Display Logic
    
    func displayTodoDetail(viewModel: TodoDetail.FetchTodoDetail.ViewModel) {
        self.viewModel = viewModel
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // อัพเดต UI ด้วยข้อมูลจาก viewModel
            self.titleLabel.text = viewModel.title
            self.categoryLabel.text = viewModel.category
            self.descriptionTextView.text = viewModel.description
            
            // กำหนดสีให้ category
            self.categoryView.backgroundColor = viewModel.categoryColor
            
            // กำหนดสถานะ
            self.statusLabel.text = viewModel.isCompleted ? "Completed" : "Not Completed"
            self.statusLabel.textColor = viewModel.isCompleted ? .systemGreen : .systemBlue
            self.statusCheckmarkImageView.image = viewModel.isCompleted ? 
                UIImage(systemName: "checkmark.circle.fill") : 
                UIImage(systemName: "circle")
            
            // กำหนดข้อความบน button
            self.markCompletedButton.setTitle(viewModel.statusButtonTitle, for: .normal)
            
            // กำหนดวันที่
            self.createdDateLabel.text = viewModel.createdAt
            self.updatedDateLabel.text = viewModel.updatedAt
            
            if let dueDate = viewModel.dueDate {
                self.dueDateLabel.text = dueDate
            } else {
                self.dueDateLabel.text = "No deadline"
            }
        }
    }
    
    func displayToggledTodoStatus(viewModel: TodoDetail.ToggleTodoStatus.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // ลบ loading indicator
            self.removeLoadingIndicator(from: self.markCompletedButton)
            
            // แสดง toast message
            self.showToast(message: viewModel.message)
            
            // ถ้าสำเร็จ ให้ refresh ข้อมูล
            if viewModel.success {
                self.fetchTodoDetail()
            }
        }
    }
    
    func displayDeletedTodo(viewModel: TodoDetail.DeleteTodo.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // ลบ loading indicator
            self.removeLoadingIndicator(from: self.deleteButton)
            
            // แสดง toast message
            self.showToast(message: viewModel.message)
            
            // ถ้าสำเร็จ ให้นำทางกลับ
            if viewModel.success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.router?.routeBackToList()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func showLoadingIndicator(on button: UIButton) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        activityIndicator.tag = 999 // ใช้ tag เพื่อระบุ indicator
        
        button.setTitle("", for: .normal)
        button.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
    
    private func removeLoadingIndicator(from button: UIButton) {
        if let indicator = button.viewWithTag(999) as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            
            // คืนค่าข้อความปุ่มเดิม
            if button == markCompletedButton {
                button.setTitle(viewModel?.statusButtonTitle, for: .normal)
            } else if button == deleteButton {
                button.setTitle("Delete", for: .normal)
            }
        }
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
