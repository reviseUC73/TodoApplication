//
//  FilterOptionsView.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol FilterOptionsViewDelegate: AnyObject {
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didSelectFilter filter: FilterOptionsView.FilterOption)
}

class FilterOptionsView: UIView {
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case todo = "To do"
        case inProgress = "In Progress"
        case completed = "Completed"
        
        var systemImageName: String {
            switch self {
            case .all: return "1list.bullet"
            case .todo: return "1circle"
            case .inProgress: return "1arrow.triangle.2.circlepath"
            case .completed: return "1checkmark.circle"
            }
        }
    }
    
    // MARK: - UI Components
    private lazy var filterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    private var filterButtons: [UIButton] = []
    private var selectedFilter: FilterOption = .all
    weak var delegate: FilterOptionsViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupFilterButtons()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupFilterButtons()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(filterScrollView)
        filterScrollView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: topAnchor),
            filterScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            containerStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor)
        ])
    }
    
    private func setupFilterButtons() {
        // Create buttons for each filter option
        for (index, option) in FilterOption.allCases.enumerated() {
            let button = createFilterButton(for: option)
            containerStackView.addArrangedSubview(button)
            filterButtons.append(button)
            
            // Select first button by default
            if index == 0 {
                selectButton(button)
            }
        }
    }
    
    private func createFilterButton(for option: FilterOption) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(option.rawValue, for: .normal)
        
        if let image = UIImage(systemName: option.systemImageName) {
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
        
        button.tintColor = .systemGray
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.tag = FilterOption.allCases.firstIndex(of: option) ?? 0
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Actions
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        // Reset all buttons
        for button in filterButtons {
            unselectButton(button)
        }
        
        // Select tapped button
        selectButton(sender)
        
        // Get selected filter and notify delegate
        let filterIndex = sender.tag
        let selectedFilter = FilterOption.allCases[filterIndex]
        self.selectedFilter = selectedFilter
        delegate?.filterOptionsView(self, didSelectFilter: selectedFilter)
    }
    
    // MARK: - Helper Methods
    
    private func selectButton(_ button: UIButton) {
        button.backgroundColor = .systemIndigo
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
    }
    
    private func unselectButton(_ button: UIButton) {
        button.backgroundColor = .systemGray6
        button.tintColor = .systemGray
        button.setTitleColor(.systemGray, for: .normal)
    }
    
    // MARK: - Public Methods
    
    func setSelectedFilter(_ filter: FilterOption) {
        selectedFilter = filter
        
        // Update button UI
        for (index, button) in filterButtons.enumerated() {
            if FilterOption.allCases[index] == filter {
                selectButton(button)
            } else {
                unselectButton(button)
            }
        }
    }
}
