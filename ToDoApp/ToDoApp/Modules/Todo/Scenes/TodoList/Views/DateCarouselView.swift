//
//  DateCarouselView.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol DateCarouselViewDelegate: AnyObject {
    func dateCarouselView(_ dateCarouselView: DateCarouselView, didSelectDate date: Date)
}

class DateCarouselView: UIView {
    
    // MARK: - Constants
    private let numberOfDays = 15
    private let dayWidth: CGFloat = 70
    private let dayHeight: CGFloat = 80
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: dayWidth, height: dayHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Properties
    private var days: [Date] = []
    private var selectedIndex: Int = 0
    weak var delegate: DateCarouselViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDays()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupDays()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupDays() {
        let calendar = Calendar.current
        let today = Date()
        
        days = (0..<numberOfDays).map { offset in
            return calendar.date(byAdding: .day, value: offset, to: today) ?? today
        }
        
        // Select today by default
        selectedIndex = 0
        collectionView.reloadData()
        
        // Notify delegate about initial selection
        delegate?.dateCarouselView(self, didSelectDate: days[selectedIndex])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DateCarouselView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let date = days[indexPath.item]
        let isSelected = indexPath.item == selectedIndex
        
        cell.configure(with: date, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        
        let selectedDate = days[indexPath.item]
        delegate?.dateCarouselView(self, didSelectDate: selectedDate)
    }
}

// MARK: - DateCollectionViewCell
class DateCollectionViewCell: UICollectionViewCell {
    static let identifier = "DateCollectionViewCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(containerView)
        containerView.addSubview(monthLabel)
        containerView.addSubview(dayLabel)
        containerView.addSubview(weekdayLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            monthLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            monthLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            monthLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 4),
            dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            weekdayLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            weekdayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            weekdayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            weekdayLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with date: Date, isSelected: Bool) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        // Get month
        dateFormatter.dateFormat = "MMM"
        monthLabel.text = dateFormatter.string(from: date)
        
        // Get day
        dayLabel.text = "\(calendar.component(.day, from: date))"
        
        // Get weekday
        dateFormatter.dateFormat = "EEE"
        weekdayLabel.text = dateFormatter.string(from: date)
        
        // Update appearance based on selection state
        if isSelected {
            containerView.backgroundColor = .systemIndigo
            monthLabel.textColor = .white
            dayLabel.textColor = .white
            weekdayLabel.textColor = .white
        } else {
            containerView.backgroundColor = .white
            monthLabel.textColor = .secondaryLabel
            dayLabel.textColor = .label
            weekdayLabel.textColor = .secondaryLabel
        }
    }
}
