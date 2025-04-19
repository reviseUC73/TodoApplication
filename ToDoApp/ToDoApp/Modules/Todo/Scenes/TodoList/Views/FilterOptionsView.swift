//
//  FilterOptionsView.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol FilterOptionsViewDelegate: AnyObject {
    func filterOptionsView(_ filterOptionsView: FilterOptionsView,
                           didSelectFilter filter: FilterOptionsView.FilterOption)
}

class FilterOptionsView: UIView {
    
    enum FilterOption: String, CaseIterable {
        case all       = "All"
        case todo      = "To do"
        case completed = "Completed"
        
        var systemImageName: String {
            switch self {
            case .all:       return "1list.bullet"
            case .todo:      return "2circle"
            case .completed: return "3checkmark.circle"
            }
        }
    }
    
    // MARK: - UI Components
    
    private lazy var filterScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let containerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 24
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: - Properties
    
    private var filterButtons: [UIButton] = []
    weak var delegate: FilterOptionsViewDelegate?
    
    // MARK: - Init
    
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
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(filterScrollView)
        filterScrollView.addSubview(containerStackView)
        
        let contentGuide = filterScrollView.contentLayoutGuide
        let frameGuide   = filterScrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            // Scroll view fills self
            filterScrollView.topAnchor.constraint(equalTo: topAnchor),
            filterScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            filterScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // StackView inside scrollView
            containerStackView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            containerStackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentGuide.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentGuide.trailingAnchor, constant: -16),
            
            // Center horizontally in the visible area
            containerStackView.centerXAnchor.constraint(equalTo: frameGuide.centerXAnchor),
            
            // Fix height
            containerStackView.heightAnchor.constraint(equalTo: frameGuide.heightAnchor)
        ])
    }
    
    // MARK: - Buttons
    
    private func setupFilterButtons() {
        for (idx, option) in FilterOption.allCases.enumerated() {
            let btn = createFilterButton(for: option)
            btn.tag = idx
            btn.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            containerStackView.addArrangedSubview(btn)
            filterButtons.append(btn)
            
            if idx == 0 {
                selectButton(btn)
            }
        }
    }
    
    private func createFilterButton(for option: FilterOption) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(option.rawValue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        // Icon + text
        if let img = UIImage(systemName: option.systemImageName) {
            btn.setImage(img, for: .normal)
            btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 8)
            btn.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        }
        
        // Style
        btn.tintColor = .systemGray
        btn.setTitleColor(.systemGray, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 12
        
        // เพิ่มขนาดปุ่ม (padding รอบตัวอักษร)
        btn.contentEdgeInsets = .init(top: 8, left: 24, bottom: 8, right: 24)
        
        // เพิ่ม shadow เล็กน้อย
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.1
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 4
        
        return btn
    }
    
    // MARK: - Actions
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        filterButtons.forEach { unselectButton($0) }
        selectButton(sender)
        
        let selected = FilterOption.allCases[sender.tag]
        delegate?.filterOptionsView(self, didSelectFilter: selected)
    }
    
    // MARK: - Helpers
    
    private func selectButton(_ btn: UIButton) {
        switch btn.tag {
        case 1:
            btn.backgroundColor = .systemBlue
        case 2:
            btn.backgroundColor = .systemGreen
        default:
            btn.backgroundColor = .systemIndigo
        }
        
        btn.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
    }
    
    private func unselectButton(_ btn: UIButton) {
        btn.backgroundColor = .white
        btn.tintColor = .systemGray
        btn.setTitleColor(.systemGray, for: .normal)
    }
    
    // MARK: - Public
    
    func setSelectedFilter(_ filter: FilterOption) {
        for (idx, btn) in filterButtons.enumerated() {
            FilterOption.allCases[idx] == filter ? selectButton(btn) : unselectButton(btn)
        }
    }
}
