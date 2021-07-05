//
//  MainTaskCell.swift
//  Ya.Do
//
//  Created by msc on 17.06.2021.
//

import UIKit
import DevToDoPod

class MainTaskCell: UITableViewCell {
    static let identifier = "MainTaskCell"
    var buttonTap: () -> Void = { }

    let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var screamerImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = Images.markImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var taskTitleLabel: UILabel = UILabel.createLabel(font: Fonts.regular17,
                                                           textLabel: "",
                                                           textAlignment: .left,
                                                           color: Colors.blackTitle ?? UIColor())

    lazy var deadlineLabel: UILabel = UILabel.createLabel(font: Fonts.system15,
                                                          textLabel: "",
                                                          textAlignment: .left,
                                                          color: Colors.grayTitle ?? UIColor())

    lazy var deadlineStack: UIStackView = createTitleStack(label: deadlineLabel,
                                                           image: Images.calendar,
                                                           spacing: 3.5)
    lazy var taskTitleStack: UIStackView = createTitleStack(label: taskTitleLabel,
                                                            image: Images.markImage,
                                                            spacing: 5)
    lazy var titleDateStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = Colors.viewsBlock
        accessoryType = .disclosureIndicator
        separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        deadlineStack.isHidden = true
        checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        setupLayout()
    }

    @objc private func didTapCheckButton() {
        buttonTap()
    }
    private func setupLayout() {
        setupCheckButtonLayout()
        setupTitleDateStack()
    }
   private func setupTitleDateStack() {
        titleDateStackView = UIStackView(arrangedSubviews: [taskTitleStack, deadlineStack])
        titleDateStackView.axis = .vertical
        titleDateStackView.spacing = 5
        titleDateStackView.alignment = .leading
        titleDateStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleDateStackView)

        NSLayoutConstraint.activate([
            titleDateStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleDateStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 52),
            titleDateStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38)
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
        if item.priority != .important {
            taskTitleStack.arrangedSubviews[0].isHidden = true
        }
        if let deadline = item.deadline {
            deadlineLabel.text = Date.returnString(from: deadline)
            deadlineStack.isHidden = false
        }
        if item.isCompleted {
            checkButton.setImage(Images.fillCircle, for: .normal)
            checkButton.tintColor =  Colors.green
            taskTitleLabel.textColor = Colors.grayTitle
        } else {
            checkButton.setImage(Images.circle, for: .normal)
            taskTitleLabel.textColor = Colors.blackTitle
            item.priority == .important ? (checkButton.tintColor = Colors.red) : (checkButton.tintColor = Colors.grayLines)
        }
    }
    func createTitleStack(label: UILabel, image: UIImage?, spacing: CGFloat) -> UIStackView {
        let imageView = UIImageView()
        imageView.image = image ?? UIImage()
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.frame.size = CGSize(width: imageView.frame.width + label.frame.width, height: imageView.frame.height)
        return stackView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
