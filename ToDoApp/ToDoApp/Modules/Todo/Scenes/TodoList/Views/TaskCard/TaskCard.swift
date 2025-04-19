//
//  TaskCard.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 18/4/2568 BE.
//

import UIKit


class TaskCard: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }

    private func loadFromNib() {
        let nib = UINib(nibName: "TaskCard", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
    }

    func configure(title: String, time: String, category: String) {
        titleLabel.text = title
        timeLabel.text = time
        categoryButton.setTitle(category, for: .normal)
    }
}
