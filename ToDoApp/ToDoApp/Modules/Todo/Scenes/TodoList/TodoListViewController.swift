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
        case todo
        case completed
        
        var title: String {
            switch self {
            case .todo:
                return "To Do"
            case .completed:
                return "Completed"
            }
        }
    }
    
    // MARK: - Clean Swift
    var interactor: TodoListBusinessLogic?
    var router: (NSObjectProtocol & TodoListRoutingLogic & TodoListDataPassing)?
    
    // MARK: - UI Components
    private let backgroundView = GradientBackgroundView()
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dateCarouselView: DateCarouselView = {
        let view = DateCarouselView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var filterOptionsView: FilterOptionsView = {
        let view = FilterOptionsView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var todoSectionView: SectionHeaderView = {
        let view = SectionHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var todoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var completedSectionView: SectionHeaderView = {
        let view = SectionHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var completedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "list.bullet.clipboard"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "No Todo task yet. Tap '+' to add one."
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func makeCenteredTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Todo List"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }
    
    // MARK: - Properties
    private var displayedTodos: [TodoList.FetchTodos.ViewModel.DisplayedTodo] = []
    private var sections: [Section] = [.todo, .completed]
    private var selectedDate: Date = Date()
    private var selectedFilter: FilterOptionsView.FilterOption = .all
    
    // Filtered todos
    private var filteredTodos: [TodoList.FetchTodos.ViewModel.DisplayedTodo] {
        return displayedTodos.filter { todo in
            switch selectedFilter {
            case .all:
                return true
            case .todo:
                return !todo.isCompleted
            case .completed:
                return todo.isCompleted
            }
        }
    }
    
    // Grouped todos
    private var todoItems: [TodoList.FetchTodos.ViewModel.DisplayedTodo] {
        return filteredTodos.filter { !$0.isCompleted }
    }
    
    private var completedTodos: [TodoList.FetchTodos.ViewModel.DisplayedTodo] {
        return filteredTodos.filter { $0.isCompleted }
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
        
        // เพิ่ม observer สำหรับ TodoCreated notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(todoCreated),
            name: NSNotification.Name("TodoCreated"),
            object: nil
        )
    }
    
    deinit {
        // ลบ observer เมื่อ view controller ถูกทำลาย
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // บังคับให้โหลดข้อมูลใหม่ทุกครั้งเมื่อกลับมาที่หน้านี้ เพื่อแสดงข้อมูลล่าสุด
        fetchTodos(ignoreCache: true)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Setup background
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundView)
        
        setupNavigationBar()
        
        // Add scrollable content
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentStackView)
        
        // Increase overall content padding
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        
        // Increase spacing between stack view items
        contentStackView.spacing = 20
        
        // Add UI components to stack view
        contentStackView.addArrangedSubview(dateCarouselView)
        contentStackView.addArrangedSubview(filterOptionsView)
        contentStackView.addArrangedSubview(todoSectionView)
        contentStackView.addArrangedSubview(todoStackView)
        contentStackView.addArrangedSubview(completedSectionView)
        contentStackView.addArrangedSubview(completedStackView)
        
        // Add padding between section header and content
        todoStackView.spacing = 16
        completedStackView.spacing = 16
        
        // Add empty state and add button on top
        view.addSubview(emptyStateView)
        view.addSubview(addButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -100),
            contentStackView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            
            dateCarouselView.heightAnchor.constraint(equalToConstant: 100),
            filterOptionsView.heightAnchor.constraint(equalToConstant: 50),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyStateView.heightAnchor.constraint(equalToConstant: 200),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Configure section headers
        todoSectionView.configure(for: .todo, itemCount: 0)
        completedSectionView.configure(for: .completed, itemCount: 0)
    }

    
    private func setupNavigationBar() {
        // Make navigation bar transparent so your gradient shows through
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        
        // Use small titles so we can center via titleView
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Create a centered label for the title
        let titleLabel = UILabel()
        titleLabel.text = "Todo List"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
        
        // Configure the refresh button in dark gray
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshButtonTapped)
        )
        refreshButton.tintColor = .darkGray
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        router?.routeToAddTodo()
    }
    
    @objc private func refreshButtonTapped() {
        // แสดง loading indicator
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
        
        // เรียกใช้ fetchTodos พร้อมกับ ignoreCache=true
        fetchTodos(ignoreCache: true)
        
        // คืนค่าปุ่มเดิมหลังจากเวลาผ่านไป 1 วินาที
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            let refreshButton = UIBarButtonItem(
                barButtonSystemItem: .refresh,
                target: self,
                action: #selector(self.refreshButtonTapped)
            )
            refreshButton.tintColor = .darkGray
            self.navigationItem.rightBarButtonItem = refreshButton
        }
    }
    
    // MARK: - Business Logic
    private func fetchTodos(ignoreCache: Bool = false) {
        let request = TodoList.FetchTodos.Request(ignoreCache: ignoreCache)
        interactor?.fetchTodos(request: request)
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        // Clear current todo views
        todoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        completedStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Update section headers
        todoSectionView.configure(for: .todo, itemCount: todoItems.count)
        completedSectionView.configure(for: .completed, itemCount: completedTodos.count)
        
        // Show/hide empty state
        emptyStateView.isHidden = !filteredTodos.isEmpty
        
        // If there are no todos in a section, hide the section
        todoSectionView.isHidden = todoItems.isEmpty
        todoStackView.isHidden = todoItems.isEmpty
        completedSectionView.isHidden = completedTodos.isEmpty
        completedStackView.isHidden = completedTodos.isEmpty
        
        // Add swipeable todo cards for todo items
        for todo in todoItems {
            let swipeableTodoCard = SwipeableTodoCardView()
            swipeableTodoCard.configure(with: todo, delegate: self)
            todoStackView.addArrangedSubview(swipeableTodoCard)
            
            // Set height constraint for the card
            swipeableTodoCard.heightAnchor.constraint(equalToConstant: 110).isActive = true
        }
        
        // Add swipeable todo cards for completed todos
        for todo in completedTodos {
            let swipeableTodoCard = SwipeableTodoCardView()
            swipeableTodoCard.configure(with: todo, delegate: self)
            completedStackView.addArrangedSubview(swipeableTodoCard)
            
            // Set height constraint for the card
            swipeableTodoCard.heightAnchor.constraint(equalToConstant: 110).isActive = true
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
            
            UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    // MARK: - Notification Handlers
    @objc private func todoCreated() {
        // ทำให้แน่ใจว่าการอัปเดต UI ทำงานบน main thread เท่านั้น
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // แสดง loading indicator
            let loadingIndicator = UIActivityIndicatorView(style: .medium)
            loadingIndicator.startAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
            
            // โหลดข้อมูลใหม่โดยบังคับไม่ใช้ cache
            self.fetchTodos(ignoreCache: true)
            
            // คืนค่าปุ่มเดิมหลังจากเวลาผ่านไป 1 วินาที
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                
                let refreshButton = UIBarButtonItem(
                    barButtonSystemItem: .refresh,
                    target: self,
                    action: #selector(self.refreshButtonTapped)
                )
                refreshButton.tintColor = .darkGray
                self.navigationItem.rightBarButtonItem = refreshButton
            }
        }
    }
}

// MARK: - Display Logic
extension TodoListViewController {
    func displayTodos(viewModel: TodoList.FetchTodos.ViewModel) {
        displayedTodos = viewModel.displayedTodos
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateUI()
        }
    }
    
    func displayAddedTodo(viewModel: TodoList.AddTodo.ViewModel) {
        showToast(message: viewModel.message)
        fetchTodos() // Refresh todos after adding
    }
    
    func displayToggledTodoStatus(viewModel: TodoList.ToggleTodoStatus.ViewModel) {
        showToast(message: viewModel.message)
        fetchTodos() // Refresh todos after toggling status
    }
    
    func displayDeletedTodo(viewModel: TodoList.DeleteTodo.ViewModel) {
        showToast(message: viewModel.message)
        fetchTodos() // Refresh todos after deletion
    }
}


// MARK: - DateCarouselViewDelegate
extension TodoListViewController: DateCarouselViewDelegate {
    func dateCarouselView(_ dateCarouselView: DateCarouselView, didSelectDate date: Date) {
        selectedDate = date
        // In a real app, you would filter todos by this date
        // For now, we'll just refresh the UI
        fetchTodos()
    }
}

// MARK: - FilterOptionsViewDelegate
extension TodoListViewController: FilterOptionsViewDelegate {
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didSelectFilter filter: FilterOptionsView.FilterOption) {
        selectedFilter = filter
        updateUI()
    }
}

// MARK: - SwipeableTodoCardViewDelegate
extension TodoListViewController: SwipeableTodoCardViewDelegate {
    func swipeableTodoCardView(_ cardView: SwipeableTodoCardView, didToggleCompletionStatus isCompleted: Bool, forTodoWithId id: String) {
        // Create request to toggle todo status
        let request = TodoList.ToggleTodoStatus.Request(
            id: id,
            isCompleted: !isCompleted
        )
        
        // Call interactor to update the todo status
        interactor?.toggleTodoStatus(request: request)
    }
    
    func swipeableTodoCardViewDidLongPress(_ cardView: SwipeableTodoCardView, forTodoWithId id: String) {
        // Show action sheet for additional options
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            let request = TodoList.DeleteTodo.Request(id: id)
            self.interactor?.deleteTodo(request: request)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    func swipeableTodoCardView(_ cardView: SwipeableTodoCardView, didSwipeToDeleteTodoWithId id: String) {
        // Create request to delete the todo
        let request = TodoList.DeleteTodo.Request(id: id)
        interactor?.deleteTodo(request: request)
    }
}

//// MARK: - TodoCardViewDelegate
//extension TodoListViewController: TodoCardViewDelegate {
//    func todoCardView(_ cardView: TodoCardView, didToggleCompletionStatus isCompleted: Bool, forTodoWithId id: String) {
//        // Create request to toggle todo status
//        let request = TodoList.ToggleTodoStatus.Request(
//            id: id,
//            isCompleted: !isCompleted
//        )
//        
//        // Call interactor to update the todo status
//        interactor?.toggleTodoStatus(request: request)
//    }
//    
//    func todoCardViewDidLongPress(_ cardView: TodoCardView, forTodoWithId id: String) {
//        // Show action sheet for additional options
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
//            guard let self = self else { return }
//            
//            let request = TodoList.DeleteTodo.Request(id: id)
//            self.interactor?.deleteTodo(request: request)
//        })
//        
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        
//        present(alertController, animated: true)
//    }
//}


