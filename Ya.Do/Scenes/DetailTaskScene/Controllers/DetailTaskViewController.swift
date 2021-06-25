//
//  DetailTaskViewController.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import UIKit

protocol DetailTaskViewControllerDelegate: class {
    func addItem(item: ToDoItem)
    func removeItem(item: ToDoItem)
}

class DetailTaskViewController: UIViewController {
   weak var delegate: DetailTaskViewControllerDelegate?
    let fileCache = FileCache()
    var task: ToDoItem?
    lazy var contentView = DetailView()
    override func loadView() {
        self.view = contentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        contentView.taskTextView.delegate = self
        cancelButtonAction()
        actions()
        //
        self.contentView.calendarView.isHidden = true
        self.contentView.calendarSeparatorView.isHidden = true
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
        switch task.priority {
        case .low:
            contentView.prioritySegment.selectedSegmentIndex = 0
        case .normal:
            contentView.prioritySegment.selectedSegmentIndex = 1
        case .high:
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
        let date = contentView.dateButton.titleLabel?.text
        deadline = Date.returnDate(from: date)

        switch contentView.prioritySegment.selectedSegmentIndex {
        case 0:
            priority = .low
        case 1:
            priority = .normal
        default:
            priority = .high
        }
        let item = ToDoItem(text: taskText, priority: priority, deadline: deadline)
        delegate?.addItem(item: item)
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
        delegate?.removeItem(item: task)
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
}

extension DetailTaskViewController: UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.taskTextView.resignFirstResponder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentView.taskTextView.text = ""
        contentView.taskTextView.textColor = Colors.blackTitle
    }

    func textViewDidChange(_ textView: UITextView) {
        contentView.saveButton.isEnabled = true
        contentView.saveButton.setTitleColor(Colors.blue, for: .normal)
    }
    
}
