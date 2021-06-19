//
//  AllTasksViewController.swift
//  Ya.Do
//
//  Created by msc on 17.06.2021.
//

import UIKit

class AllTasksViewController: UIViewController {
    
    var tasks = [ToDoItem]()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.backgroundColor = Colors.viewsBlock
        tableView.layer.cornerRadius = 16
        tableView.register(MainTaskCell.self, forCellReuseIdentifier: MainTaskCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    lazy var addButton: UIButton = {
       let button = UIButton()
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.tintColor = Colors.blue
        button.setBackgroundImage(Images.plus, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Colors.background
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension AllTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTaskCell.identifier, for: indexPath) as? MainTaskCell else {
            return UITableViewCell()
        }
        var task = tasks[indexPath.row]
        cell.setupCell(task)
        cell.buttonTap = {
            task.isCompleted = !task.isCompleted
            self.tasks[indexPath.row] = task
            
            switch task.isCompleted {
            case true:
                cell.checkButton.setImage(Images.fillCircle, for: .normal)
                cell.checkButton.tintColor =  Colors.green
                cell.taskTitleLabel.textColor = Colors.grayTitle
            case false:
                cell.checkButton.setImage(Images.circle, for: .normal)
                guard task.priority == .high else {
                    cell.checkButton.tintColor = Colors.grayLines
                    return
                }
                cell.checkButton.tintColor = Colors.red
                cell.taskTitleLabel.textColor = Colors.blackTitle
            }
        }
        return cell
    }

}
// MARK: - UITableViewDelegate
extension AllTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
