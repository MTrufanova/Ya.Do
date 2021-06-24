//
//  MainTaskCell.swift
//  Ya.Do
//
//  Created by msc on 17.06.2021.
//

import UIKit

class MainTaskCell: UITableViewCell {
    static let identifier = "MainTaskCell"
    var buttonTap: () -> Void = { }

    let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var taskTitleLabel: UILabel = UILabel.createLabel(font: Fonts.regular17, textLabel: "", textAlignment: .left, color: Colors.blackTitle ?? UIColor())

    lazy var deadlineLabel: UILabel = UILabel.createLabel(font: Fonts.system15, textLabel: "", textAlignment: .left, color: Colors.grayTitle ?? UIColor())
    lazy var titleDateStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = Colors.viewsBlock
        accessoryType = .disclosureIndicator
        separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        setupLayout()
    }

    @objc func didTapCheckButton() {
        buttonTap()
    }
    private func setupLayout() {
        setupCheckButtonLayout()
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
            titleDateStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 52),
            titleDateStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])

    }

    private func setupCheckButtonLayout() {
        contentView.addSubview(checkButton)
        NSLayoutConstraint.activate([
        checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        checkButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setupCell(_ item: ToDoItem) {
        taskTitleLabel.text =  item.text
        guard let deadline = item.deadline else { return }
        deadlineLabel.text = Date.stringDateFormatter(from: deadline)
        switch item.isCompleted {
        case true:
            checkButton.setImage(Images.fillCircle, for: .normal)
            checkButton.tintColor =  Colors.green
            taskTitleLabel.textColor = Colors.grayTitle

        case false:
            checkButton.setImage(Images.circle, for: .normal)
            taskTitleLabel.textColor = Colors.blackTitle
            guard item.priority == .high else {
                checkButton.tintColor = Colors.grayLines
                return
            }
            checkButton.tintColor = Colors.red
        }

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
