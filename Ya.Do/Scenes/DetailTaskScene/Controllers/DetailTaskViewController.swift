//
//  DetailTaskViewController.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import UIKit
import DevToDoPod
import CoreData

protocol DetailTaskViewControllerDelegate: class {
    func addItem(item: TodoItem)
    func removeItem(item: TodoItem)
}

class DetailTaskViewController: UIViewController {

    var presenter: DetailTaskPresenterProtocol!
    var task: TodoItem?
    lazy var contentView = DetailView()
    override func loadView() {
        self.view = contentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setTask()
        notificationsForKeyboard()
        updateUI()
        contentView.taskTextView.delegate = self
        cancelButtonAction()
        actions()
        hideKeyboardForTap()
        //
        self.contentView.calendarView.isHidden = true
        self.contentView.calendarSeparatorView.isHidden = true
    }

    private func notificationsForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func updateTextView(notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardRect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardFrame = view.convert(keyboardRect, to: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentView.taskTextView.contentInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        } else {
            guard UIDevice.current.orientation.isLandscape else {
                contentView.taskTextView.contentInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
                return
            }
            contentView.taskTextView.contentInset = UIEdgeInsets(top: 17, left: 16, bottom: keyboardFrame.width, right: 16)
        }
        contentView.taskTextView.scrollIndicatorInsets = contentView.taskTextView.contentInset
        contentView.taskTextView.scrollRangeToVisible(contentView.taskTextView.selectedRange)
    }

    private func updateUI() {
        guard let task = task else {
            contentView.taskTextView.text = Title.textViewPlaceholder
            return
        }
        contentView.taskTextView.textColor = Colors.blackTitle
        contentView.taskTextView.text = task.text
        contentView.deleteButton.setTitleColor(Colors.red, for: .normal)
        contentView.saveButton.setTitleColor(Colors.blue, for: .normal)
        guard let deadline  = task.deadline else { return }
        let date = Date.returnString(from: deadline)
        contentView.dateButton.isHidden = false
        contentView.dateButton.setTitle(date, for: .normal)
        contentView.datePicker.date = deadline
        // switch task.priority {
        switch task.importance {
        case .low:
            contentView.prioritySegment.selectedSegmentIndex = 0
        case .basic:
            contentView.prioritySegment.selectedSegmentIndex = 1
        case .important:
            contentView.prioritySegment.selectedSegmentIndex = 2
        }
    }

    private func actions() {
        contentView.calendarSwitch.addTarget(self, action: #selector(switchAction(calendarSwitch:)), for: .valueChanged)
        contentView.deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        contentView.datePicker.addTarget(self, action: #selector(datePickerAction), for: .valueChanged)
        contentView.dateButton.addTarget(self, action: #selector(dateButtonAction), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }
    // MARK: - Action for Button
    @objc private func saveButtonAction() {
        guard let taskText = contentView.taskTextView.text else {return}
        let deadline: Date?
        let priority: ToDoItem.Priority
        let createDate = Date().timeIntervalSince1970
        let date = contentView.dateButton.titleLabel?.text
        deadline = Date.returnDate(from: date)

        switch contentView.prioritySegment.selectedSegmentIndex {
        case 0:
            priority = .low
        case 1:
            priority = .basic
        default:
            priority = .important
        }
        guard let task = task else {
            let itemDo = presenter.createItem(text: taskText, priority: priority, deadline: deadline, createdAt: Int64(createDate), updatedAt: nil)
            guard let item = itemDo else { return }
            presenter.addItem(item: item)
            return
        }
        task.text = taskText
        task.deadline = deadline
        task.importance = priority
        task.updatedAt = Date()
        presenter.addItem(item: task)

    }
    func cancelButtonAction() {
        contentView.cancelButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func dateButtonAction() {
        if contentView.calendarView.isHidden == true {
            UIView.animate(withDuration: 0.5) {
                self.contentView.calendarView.isHidden = false
                self.contentView.calendarSeparatorView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.contentView.calendarView.isHidden = true
                self.contentView.calendarSeparatorView.isHidden = true
            }
        }
    }

    @objc private func deleteButtonAction() {
        guard let task = task else { return  }
        presenter.removeItem(item: task)
    }
    // MARK: - SwitchAction
    @objc private func switchAction(calendarSwitch: UISwitch) {
        if calendarSwitch.isOn {
            let dateTitle = Date.returnString(from: contentView.datePicker.date)
            self.contentView.dateButton.isHidden = false
            self.contentView.dateButton.setTitle("\(dateTitle)", for: .normal)
        } else {
            self.contentView.dateButton.setTitle("", for: .normal)
        }
    }

    @objc private func datePickerAction() {
        let dateTitle = Date.returnString(from: contentView.datePicker.date)
        contentView.dateButton.setTitle("\(dateTitle)", for: .normal)
    }
    // MARK: - Method for landscape/ portret constraints
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate(contentView.portraitConstraints)
            NSLayoutConstraint.activate(contentView.landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(contentView.portraitConstraints)
            NSLayoutConstraint.deactivate(contentView.landscapeConstraints)
        }
    }
}
// MARK: - UITextViewDelegate
extension DetailTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentView.taskTextView.text = ""
        contentView.taskTextView.textColor = Colors.blackTitle
    }

    func textViewDidChange(_ textView: UITextView) {
        contentView.saveButton.isEnabled = true
        contentView.saveButton.setTitleColor(Colors.blue, for: .normal)
    }
}
// MARK: - Dismiss Keyboard
extension DetailTaskViewController {
    func hideKeyboardForTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboardView() {
        view.endEditing(true)
    }
}

extension DetailTaskViewController: DetailTaskProtocol {
    func setTask(task: TodoItem?) {
        self.task = task
    }
}
