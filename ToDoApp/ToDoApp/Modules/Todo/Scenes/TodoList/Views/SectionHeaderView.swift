//
//  SectionHeaderView.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

class SectionHeaderView: UIView {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        containerView.addSubview(colorIndicator)
        containerView.addSubview(titleLabel)
        containerView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            colorIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            colorIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            colorIndicator.widthAnchor.constraint(equalToConstant: 6),
            colorIndicator.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(equalTo: colorIndicator.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -8),
            
            countLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            countLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            countLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(for section: TodoListViewController.Section, itemCount: Int) {
        titleLabel.text = section.title
        countLabel.text = "\(itemCount)"
        
        // Set color based on section type
        switch section {
        case .inProgress:
            colorIndicator.backgroundColor = .systemBlue
        case .completed:
            colorIndicator.backgroundColor = .systemGreen
        }
    }
}
