//
//  AddItemCell.swift
//  Ya.Do
//
//  Created by msc on 19.06.2021.
//

import UIKit

class AddItemCell: UITableViewCell {

    static let identifier = "addItemCell"
    lazy var newItemLabel = UILabel.createLabel(font: Fonts.regular17, textLabel: Title.new, textAlignment: .left, color: Colors.grayTitle ?? UIColor())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = Colors.viewsBlock
        self.roundCorners([.bottomLeft, .bottomRight], radius: 16)
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        setupLayout()
    }

    private func setupLayout() {
        addSubview(newItemLabel)

        NSLayoutConstraint.activate([

            newItemLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            newItemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
