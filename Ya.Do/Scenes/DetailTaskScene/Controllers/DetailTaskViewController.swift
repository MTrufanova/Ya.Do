//
//  DetailTaskViewController.swift
//  Ya.Do
//
//  Created by msc on 10.06.2021.
//

import UIKit

class DetailTaskViewController: UIViewController {

    let fileCache = FileCache()
    var task: ToDoItem?
    lazy var contentView = DetailView()
    override func loadView() {
        self.view = contentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9490196078, alpha: 1)
        contentView.taskTextView.delegate = self
        cancelButtonAction()
        contentView.calendarSwitch.addTarget(self, action: #selector(switchAction(calendarSwitch:)), for: .valueChanged)
        contentView.deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        contentView.datePicker.addTarget(self, action: #selector(datePickerAction), for: .valueChanged)
        contentView.dateButton.addTarget(self, action: #selector(dateButtonAction), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        self.contentView.calendarView.isHidden = true
        self.contentView.calendarSeparatorView.isHidden = true
        self.contentView.dateButton.isHidden = true
    }
    // MARK: - Action for Button
    @objc func saveButtonAction() {
        guard let taskText = contentView.taskTextView.text else {return}
        let date: Date?
        let priority: Priority
        guard contentView.dateButton.titleLabel?.text != "" else { date = nil
            return }
        date = contentView.datePicker.date

        switch contentView.prioritySegment.selectedSegmentIndex {
        case 0:
            priority = .low
        case 1:
            priority = .normal
        default:
            priority = .high
        }

        fileCache.addTask(ToDoItem(text: taskText, priority: priority, date: date))
        fileCache.saveAllTasks(at: "default.json")
        dismissModal()
    }
    func cancelButtonAction() {
        contentView.cancelButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    @objc func dismissModal() {
    self.dismiss(animated: true, completion: nil)
    }

    @objc func dateButtonAction() {
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

    @objc func deleteButtonAction() {
        contentView.taskTextView.text = ""
        contentView.prioritySegment.selectedSegmentIndex = 1
        contentView.calendarSwitch.isOn = false
        switchAction(calendarSwitch: contentView.calendarSwitch)
        let buttonColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
        contentView.deleteButton.setTitleColor(buttonColor, for: .normal)
        contentView.datePicker.date = tomorrow
        guard let id = task?.id else { return  }
        fileCache.removeTask(at: id)
        fileCache.saveAllTasks(at: "default.json")
    }

    // MARK: - SwitchAction
    @objc func switchAction(calendarSwitch: UISwitch) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateTitle = formatter.string(from: contentView.datePicker.date)
        if calendarSwitch.isOn {
                self.contentView.dateButton.isHidden = false
                self.contentView.dateButton.setTitle("\(dateTitle)", for: .normal)
        } else {
                self.contentView.dateButton.setTitle("", for: .normal)
        }
    }

    @objc func datePickerAction() {
        let dateTitle = stringDateFormatter(from: contentView.datePicker.date)
        contentView.dateButton.setTitle("\(dateTitle)", for: .normal)
    }

}

extension DetailTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentView.taskTextView.text = ""
        contentView.taskTextView.textColor = .black
    }

    func textViewDidChange(_ textView: UITextView) {
        contentView.saveButton.isEnabled = true
        contentView.saveButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        contentView.deleteButton.setTitleColor(#colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1), for: .normal)
    }
}
