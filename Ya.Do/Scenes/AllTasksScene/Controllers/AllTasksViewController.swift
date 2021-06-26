//
//  AllTasksViewController.swift
//  Ya.Do
//
//  Created by msc on 17.06.2021.
//

import UIKit

class AllTasksViewController: UIViewController {
    private let fileCache = FileCache()
    
    private var isFiltering: Bool {
        return hiddenButton.titleLabel?.text == Title.show
    }
    lazy var counterLabel = UILabel.createLabel(font: Fonts.system15, textLabel: "\(self.countDone())", textAlignment: .left, color: Colors.grayTitle ?? UIColor())
    
    lazy var hiddenButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Colors.blue, for: .normal)
        button.titleLabel?.font = Fonts.semibold15
        button.setTitle(Title.show, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 1, left: 76, bottom: 1, right: 0)
        button.addTarget(self, action: #selector(showDone), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.register(MainTaskCell.self, forCellReuseIdentifier: MainTaskCell.identifier)
        tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identifier)
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
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Title.tasksAll
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Colors.background
        fileCache.getAllItems(from: Files.defaultFile)
        setupLayout()
    }
    
    @objc private func showDone() {
        if hiddenButton.titleLabel?.text == Title.show {
            hiddenButton.setTitle(Title.hide, for: .normal)
            tableView.reloadData()
        } else {
            hiddenButton.setTitle(Title.show, for: .normal)
            tableView.reloadData()
        }
    }
    // MARK: - Method for count completed tasks
    private func countDone() -> String {
        let count = fileCache.tasks.filter { $0.isCompleted == true }.count
        return Title.done + "\(count)"
    }
    
    private func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { [self] (_, _, completion) in
            var task: ToDoItem
            if isFiltering {
                fileCache.returnCompleted()
                task = fileCache.completedTasks[indexPath.row]
                // self.fileCache.updateFilterItem(index: indexPath.row, item: task)
            } else {
                task = fileCache.tasks[indexPath.row]
                
            }
            task.isCompleted = !task.isCompleted
            self.fileCache.updateItem(index: indexPath.row, item: task)
            self.fileCache.saveAllItems(to: Files.defaultFile)
            tableView.reloadData()
            completion(true)
        }
        action.backgroundColor = .systemGreen
        action.image = Images.fillCircle
        return action
    }
    
    private func deleteSwipeAction(at indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: nil) { [self] (_, _, completion) in
            var task: ToDoItem
            if isFiltering {
                task = fileCache.completedTasks[indexPath.row]
            } else {
                task = fileCache.tasks[indexPath.row]
            }
            let id = task.id
            fileCache.removeItem(at: id)
            tableView.deleteRows(at: [indexPath], with: .fade)
            fileCache.saveAllItems(to: Files.defaultFile)
            self.counterLabel.text = "\(self.countDone())"
        }
        delete.image = Images.trash
        delete.backgroundColor = Colors.red
        return delete
    }
    
    private func infoSwipeAction(at indexPath: IndexPath) -> UIContextualAction {
        let infoSwipe = UIContextualAction(style: .normal, title: nil) { [self] (_, _, completion) in
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            switch indexPath.row {
            case lastRowIndex - 1:
                addNewItem()
            default:
                var task: ToDoItem
                if isFiltering {
                    let completed = fileCache.completedTasks[indexPath.row].id
                    guard let index = fileCache.tasks.firstIndex(where: { $0.id == completed }) else {return}
                    task = fileCache.tasks[index]
                } else {
                    task = fileCache.tasks[indexPath.row]
                }
                let addVC = DetailTaskViewController()
                addVC.task = task
                addVC.delegate = self
                addVC.modalPresentationStyle = .formSheet
                navigationController?.present(addVC, animated: true, completion: nil)
            }
        }
        infoSwipe.image = Images.info
        infoSwipe.backgroundColor = Colors.grayBackgroundSwipe
        return infoSwipe
    }
    
    @objc private func addNewItem() {
        let addVC = DetailTaskViewController()
        addVC.delegate = self
        addVC.modalPresentationStyle = .formSheet
        navigationController?.present(addVC, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        setupCountAttributesLayout()
        setupTableViewLayout()
    }
    
    private func setupCountAttributesLayout() {
        view.addSubview(counterLabel)
        view.addSubview(hiddenButton)
        NSLayoutConstraint.activate([
            counterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            counterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            hiddenButton.widthAnchor.constraint(equalToConstant: 147.5),
            hiddenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            hiddenButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor)
        ])
    }
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: hiddenButton.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
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
        if isFiltering {
            fileCache.returnCompleted()
            return fileCache.completedTasks.count + 1
        }
        return fileCache.tasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        switch indexPath.row {
        case lastRowIndex - 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identifier, for: indexPath) as? AddItemCell else { return UITableViewCell() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTaskCell.identifier, for: indexPath) as? MainTaskCell else {
                return UITableViewCell()
            }
            var task: ToDoItem
            if isFiltering {
                fileCache.returnCompleted()
                task = fileCache.completedTasks[indexPath.row]
                self.fileCache.updateFilterItem(index: indexPath.row, item: task)
            } else {
                task = fileCache.tasks[indexPath.row]
                self.fileCache.updateItem(index: indexPath.row, item: task)
            }
            cell.setupCell(task)
            cell.buttonTap = {
                task.isCompleted = !task.isCompleted
                self.fileCache.updateItem(index: indexPath.row, item: task)
                self.fileCache.saveAllItems(to: Files.defaultFile)
                self.counterLabel.text = "\(self.countDone())"
                tableView.reloadData()
                switch task.isCompleted {
                case true:
                    cell.checkButton.setImage(Images.fillCircle, for: .normal)
                    cell.checkButton.tintColor =  Colors.green
                    cell.taskTitleLabel.textColor = Colors.grayTitle
                case false:
                    cell.checkButton.setImage(Images.circle, for: .normal)
                    cell.taskTitleLabel.textColor = Colors.blackTitle
                    guard task.priority == .high else {
                        cell.checkButton.tintColor = Colors.grayLines
                        return
                    }
                    cell.checkButton.tintColor = Colors.red
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        switch indexPath.row {
        case lastRowIndex - 1:
            addNewItem()
        default:
            var task: ToDoItem
            if isFiltering {
                let completed = fileCache.completedTasks[indexPath.row].id
                guard let index = fileCache.tasks.firstIndex(where: { $0.id == completed }) else {return}
                task = fileCache.tasks[index]
            } else {
                task = fileCache.tasks[indexPath.row]
            }
            let addVC = DetailTaskViewController()
            addVC.task = task
            addVC.delegate = self
            addVC.modalPresentationStyle = .formSheet
            navigationController?.present(addVC, animated: true, completion: nil)
        }
    }
}
// MARK: - UITableViewDelegate
extension AllTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        guard indexPath.row != lastRowIndex-1 else { return nil }
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        guard indexPath.row != lastRowIndex-1 else { return nil }
        let delete = deleteSwipeAction(at: indexPath)
        let info = infoSwipeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, info])
    }
}

extension AllTasksViewController: DetailTaskViewControllerDelegate {
    func removeItem(item: ToDoItem) {
        self.dismiss(animated: true) { [self] in
            fileCache.removeItem(at: item.id)
            fileCache.saveAllItems(to: Files.defaultFile)
            tableView.reloadData()
        }
    }
    
    func addItem(item: ToDoItem) {
        self.dismiss(animated: true) { [self] in
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
                switch selectedIndexPath.row {
                case lastRowIndex - 1:
                    fileCache.addItem(item)
                default:
                    
                    if isFiltering {
                        let completed = fileCache.completedTasks[selectedIndexPath.row].id
                        guard let index = fileCache.tasks.firstIndex(where: { $0.id == completed }) else {return}
                        fileCache.updateItem(index: index, item: item)
                    } else {
                        fileCache.updateItem(index: selectedIndexPath.row, item: item)
                    }
                }
            }else {
                fileCache.addItem(item)
            }
            fileCache.saveAllItems(to: Files.defaultFile)
            tableView.reloadData()
        }
    }
}
