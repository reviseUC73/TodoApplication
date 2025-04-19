//
//  AddTodoViewController.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol AddTodoDisplayLogic: AnyObject {
    func displayCreatedTodo(viewModel: AddTodo.Create.ViewModel)
    func displayCategories(viewModel: AddTodo.FetchCategories.ViewModel)
}

class AddTodoViewController: UIViewController, AddTodoDisplayLogic {
    
    // MARK: - Clean Swift
    var interactor: AddTodoBusinessLogic?
    var router: (NSObjectProtocol & AddTodoRoutingLogic & AddTodoDataPassing)?
    
    // MARK: - Properties
    private var categories: [String] = []
    private var selectedCategory: TodoCategory = .work
    private var selectedDueDate: Date?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add task"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task name"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categorySelectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryViewTapped))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    private let categoryValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Work"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryChevronImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        imageView.image = UIImage(systemName: "chevron.down", withConfiguration: config)
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dueDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set due date", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        
        // Add calendar icon
        let calendarImage = UIImage(systemName: "calendar")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        button.setImage(calendarImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(dueDateButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var timeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set Time", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        
        // Add clock icon
        let clockImage = UIImage(systemName: "clock")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        button.setImage(clockImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notesTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add shadow
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.minimumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var categoryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(pickerDoneButtonTapped))
        doneButton.tintColor = .systemBlue
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pickerCancelButtonTapped))
        
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    // MARK: - State Properties
    private var activePickerType: PickerType?
    
    private enum PickerType {
        case category
        case date
        case time
    }
    
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
        let interactor = AddTodoInteractor()
        let presenter = AddTodoPresenter()
        let router = AddTodoRouter()
        
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
        setupKeyboardDismissal()
        fetchCategories()
        
        // Set initial focus on task field
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.taskTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Add container view
        view.addSubview(containerView)
        
        // Add header with title and cancel button
        containerView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(cancelButton)
        
        // Add task name field
        containerView.addSubview(taskTextField)
        
        // Add category section
        containerView.addSubview(categoryLabel)
        containerView.addSubview(categorySelectionView)
        categorySelectionView.addSubview(categoryValueLabel)
        categorySelectionView.addSubview(categoryChevronImageView)
        
        // Add date section
        containerView.addSubview(dateLabel)
        containerView.addSubview(dueDateButton)
        containerView.addSubview(timeButton)
        
        // Add notes section
        containerView.addSubview(notesLabel)
        containerView.addSubview(notesTextView)
        
        // Add the floating add button
        view.addSubview(addButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Container constraints
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 500),
            
            // Header constraints
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Task name field constraints
            taskTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            taskTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            taskTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            taskTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Category constraints
            categoryLabel.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            categorySelectionView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            categorySelectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            categorySelectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            categorySelectionView.heightAnchor.constraint(equalToConstant: 44),
            
            categoryValueLabel.leadingAnchor.constraint(equalTo: categorySelectionView.leadingAnchor, constant: 12),
            categoryValueLabel.centerYAnchor.constraint(equalTo: categorySelectionView.centerYAnchor),
            
            categoryChevronImageView.trailingAnchor.constraint(equalTo: categorySelectionView.trailingAnchor, constant: -12),
            categoryChevronImageView.centerYAnchor.constraint(equalTo: categorySelectionView.centerYAnchor),
            categoryChevronImageView.widthAnchor.constraint(equalToConstant: 12),
            categoryChevronImageView.heightAnchor.constraint(equalToConstant: 12),
            
            // Date constraints
            dateLabel.topAnchor.constraint(equalTo: categorySelectionView.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            dueDateButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            dueDateButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dueDateButton.heightAnchor.constraint(equalToConstant: 30),
            
            timeButton.topAnchor.constraint(equalTo: dueDateButton.bottomAnchor, constant: 8),
            timeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            timeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16), // ✅ เพิ่มบรรทัดนี้
            timeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Notes constraints
            notesLabel.topAnchor.constraint(equalTo: timeButton.bottomAnchor, constant: 20),
            notesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            notesTextView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
            notesTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            notesTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            notesTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // Add button constraints
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            addButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Business Logic
    
    private func fetchCategories() {
        let request = AddTodo.FetchCategories.Request()
        interactor?.fetchCategories(request: request)
    }
    
    private func createTodo() {
        print("(selectedDueDate?.description",selectedDueDate?.description)
        guard let title = taskTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a task name")
            return
        }
        
        let description = notesTextView.text ?? ""
        
        let request = AddTodo.Create.Request(
            title: title,
            description: description,
            category: selectedCategory,
            dueDate: selectedDueDate
        )
        
        interactor?.createTodo(request: request)
    }
    
    // MARK: - Display Logic
    
    func displayCreatedTodo(viewModel: AddTodo.Create.ViewModel) {
        if viewModel.success {
            // Route back to the todo list
            router?.routeToTodoList()
        } else if let errorMessage = viewModel.errorMessage {
            showAlert(message: errorMessage)
        }
    }
    
    func displayCategories(viewModel: AddTodo.FetchCategories.ViewModel) {
        categories = viewModel.categories
        categoryPickerView.reloadAllComponents()
    }
    
    // MARK: - UI Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        dismissPicker()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        createTodo()
    }
    
    @objc private func categoryViewTapped() {
        showCategoryPicker()
    }
    
    @objc private func dueDateButtonTapped() {
        showDatePicker(mode: .date)
    }
    
    @objc private func timeButtonTapped() {
        showDatePicker(mode: .time)
    }
    
    @objc private func pickerDoneButtonTapped() {
        switch activePickerType {
        case .category:
            let selectedRow = categoryPickerView.selectedRow(inComponent: 0)
            if selectedRow >= 0 && selectedRow < categories.count {
                let categoryName = categories[selectedRow]
                categoryValueLabel.text = categoryName
                selectedCategory = TodoCategory(rawValue: categoryName) ?? .work
            }
        case .date, .time:
            if selectedDueDate == nil {
                selectedDueDate = Date()
            }
            
            let calendar = Calendar.current
            let selectedDate = datePicker.date
            
            if activePickerType == .date {
                // When date is selected, keep the existing time if there is one
                if let existingDate = selectedDueDate {
                    let existingComponents = calendar.dateComponents([.hour, .minute], from: existingDate)
                    let newComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
                    
                    var combinedComponents = DateComponents()
                    combinedComponents.year = newComponents.year
                    combinedComponents.month = newComponents.month
                    combinedComponents.day = newComponents.day
                    combinedComponents.hour = existingComponents.hour
                    combinedComponents.minute = existingComponents.minute
                    
                    selectedDueDate = calendar.date(from: combinedComponents)
                } else {
                    selectedDueDate = selectedDate
                }
                
                // Update date button text
                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "th_TH") // Set Thai locale for Buddhist calendar
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.calendar = Calendar(identifier: .buddhist) // Use Buddhist calendar
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dueDateButton.setTitle(dateFormatter.string(from: selectedDueDate!), for: .normal)
                dueDateButton.setTitleColor(.label, for: .normal)
                
            } else { // .time
                // When time is selected, keep the existing date if there is one
                if let existingDate = selectedDueDate {
                    let existingComponents = calendar.dateComponents([.year, .month, .day], from: existingDate)
                    let newComponents = calendar.dateComponents([.hour, .minute], from: selectedDate)
                    
                    var combinedComponents = DateComponents()
                    combinedComponents.year = existingComponents.year
                    combinedComponents.month = existingComponents.month
                    combinedComponents.day = existingComponents.day
                    combinedComponents.hour = newComponents.hour
                    combinedComponents.minute = newComponents.minute
                    
                    selectedDueDate = calendar.date(from: combinedComponents)
                } else {
                    selectedDueDate = selectedDate
                }
                
                // Update time button text
                let timeFormatter = DateFormatter()
//                timeFormatter.locale = Locale(identifier: "th_TH")
                timeFormatter.timeZone = TimeZone.current
                timeFormatter.dateStyle = .none
                timeFormatter.timeStyle = .short
                timeButton.setTitle(timeFormatter.string(from: selectedDueDate!), for: .normal)
                timeButton.setTitleColor(.label, for: .normal)
            }
        default:
            break
        }
        
        // For debugging, use a properly formatted date string instead of description
        let debugFormatter = DateFormatter()
        debugFormatter.locale = Locale(identifier: "th_TH")
        debugFormatter.timeZone = TimeZone.current
        debugFormatter.calendar = Calendar(identifier: .buddhist)
        debugFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ 'BE'"
        
        print("selectedDueDate formatted:", debugFormatter.string(from: selectedDueDate ?? Date()))
        print("selectedDueDate raw UTC:", selectedDueDate?.description)
        
        dismissPicker()
    }
    
    @objc private func pickerCancelButtonTapped() {
        dismissPicker()
    }
    
    // MARK: - Helper Methods
    
    private func showCategoryPicker() {
        dismissKeyboard()
        
        activePickerType = .category
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 260))
        inputView.backgroundColor = .systemBackground
        
        pickerToolbar.translatesAutoresizingMaskIntoConstraints = false // show pickerToolbar
        
        inputView.addSubview(categoryPickerView)
        inputView.addSubview(pickerToolbar)
        
        NSLayoutConstraint.activate([
            pickerToolbar.topAnchor.constraint(equalTo: inputView.topAnchor),
            pickerToolbar.leadingAnchor.constraint(equalTo: inputView.leadingAnchor),
            pickerToolbar.trailingAnchor.constraint(equalTo: inputView.trailingAnchor),
            pickerToolbar.heightAnchor.constraint(equalToConstant: 44),
            
            categoryPickerView.topAnchor.constraint(equalTo: pickerToolbar.bottomAnchor),
            categoryPickerView.leadingAnchor.constraint(equalTo: inputView.leadingAnchor),
            categoryPickerView.trailingAnchor.constraint(equalTo: inputView.trailingAnchor),
            categoryPickerView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
        ])
        
        // Find the category index to select
        if let index = categories.firstIndex(of: selectedCategory.rawValue) {
            categoryPickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        showInputView(inputView)
    }
    
    private func showDatePicker(mode: UIDatePicker.Mode) {
        dismissKeyboard()
        
        activePickerType = mode == .date ? .date : .time
        
        datePicker.datePickerMode = mode
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 260))
        inputView.backgroundColor = .systemBackground
        
        pickerToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        inputView.addSubview(datePicker)
        inputView.addSubview(pickerToolbar)
        
        NSLayoutConstraint.activate([
            pickerToolbar.topAnchor.constraint(equalTo: inputView.topAnchor),
            pickerToolbar.leadingAnchor.constraint(equalTo: inputView.leadingAnchor),
            pickerToolbar.trailingAnchor.constraint(equalTo: inputView.trailingAnchor),
            pickerToolbar.heightAnchor.constraint(equalToConstant: 44),
            
            datePicker.topAnchor.constraint(equalTo: pickerToolbar.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: inputView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: inputView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
        ])
        
        // Set the date picker to the currently selected date or current date
        datePicker.date = selectedDueDate ?? Date()
        
        showInputView(inputView)
    }
    
    private func showInputView(_ inputView: UIView) {
        inputView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(inputView)
        
        NSLayoutConstraint.activate([
            inputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Add a subtle animation
        inputView.transform = CGAffineTransform(translationX: 0, y: inputView.frame.height)
        
        UIView.animate(withDuration: 0.3) {
            inputView.transform = .identity
        }
    }
    
    private func dismissPicker() {
        for subview in view.subviews {
            if subview.frame.minY > containerView.frame.minY && subview != addButton {
                UIView.animate(withDuration: 0.3, animations: {
                    subview.transform = CGAffineTransform(translationX: 0, y: subview.frame.height)
                }) { _ in
                    subview.removeFromSuperview()
                }
            }
        }
        
        activePickerType = nil
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension AddTodoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}
