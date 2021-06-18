//
//  MainTaskCell.swift
//  Ya.Do
//
//  Created by msc on 17.06.2021.
//

import UIKit

class MainTaskCell: UITableViewCell {
    static let identifier = "MainTaskCell"
    //checkmark.circle.fill
    //circle
    lazy var taskTitleLabel: UILabel = UILabel.createLabel(font: .systemFont(ofSize: 17, weight: .regular), textLabel: "", textAlignment: .left, color: UIColor(named: "navTitle") ?? UIColor())
    
    lazy var deadlineLabel: UILabel = UILabel.createLabel(font: .systemFont(ofSize: 15, weight: .regular), textLabel: "", textAlignment: .left, color: UIColor(named: "grayText") ?? UIColor())
    lazy var titleDateStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleDateStack()
    }
    
    func setupTitleDateStack() {
        titleDateStackView = UIStackView(arrangedSubviews: [taskTitleLabel, deadlineLabel])
        titleDateStackView.axis = .vertical
        titleDateStackView.spacing = 5
        titleDateStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleDateStackView)
        
        NSLayoutConstraint.activate([
            titleDateStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleDateStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleDateStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
    }
    
    private func setupLayout() {
        
    }
    
     func setupCell() {
        taskTitleLabel.text =  "Hello"//item.text
        //guard let deadline = item.deadline else { return }
        deadlineLabel.text = "14141"//Date.stringDateFormatter(from: deadline)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
