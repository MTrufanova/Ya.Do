//
//  DetailView.swift
//  Ya.Do
//
//  Created by msc on 12.06.2021.
//

import UIKit

class DetailView: UIView {
    // MARK: - For NavBar
    lazy var titleLabel: UILabel = UILabel.createLabel(font: Fonts.semibold17, textLabel: Title.navTitleDetailVC, textAlignment: .center, color: UIColor(named: "navTitle") ?? UIColor())
    
    lazy var cancelButton: UIButton = createNavButton(title: Title.cancelButton, font: Fonts.regular17, color: UIColor(named: "blueTitle") ?? UIColor())
    
    lazy var saveButton: UIButton = createNavButton(title: Title.saveButton, font: Fonts.semibold17, color: UIColor(named: "grayText") ?? UIColor())
    
    // MARK: - UI
    lazy var taskTextView: UITextView = {
        let textView = UITextView()
        textView.text = Title.textViewPlaceholder
        textView.layer.cornerRadius = 16
        textView.textColor = UIColor(named: "grayText")
        textView.font = Fonts.regular17
        textView.backgroundColor = UIColor(named: "mainViews")
        textView.contentInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    // MARK: - UI FOR PRIORITY VIEW
    lazy var priorityView: UIView = createViewForStack()
    
    lazy var priorityLabel: UILabel = UILabel.createLabel(font: Fonts.regular17, textLabel: Title.priority, textAlignment: .left, color: UIColor(named: "navTitle") ?? UIColor())
    
    lazy var prioritySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["one", "two", "three"])
        let font: UIFont = Fonts.system15
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        let largeConfig = UIImage.SymbolConfiguration(weight: .bold)
        let arrowImage = UIImage(systemName: "arrow.down", withConfiguration: largeConfig)?.withTintColor(#colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1), renderingMode: .alwaysOriginal)
        let markImage = UIImage(systemName: "exclamationmark.2", withConfiguration: largeConfig)?.withTintColor(UIColor(named: "redTitle") ?? UIColor(), renderingMode: .alwaysOriginal)
        segment.selectedSegmentIndex = 1
        segment.setImage(arrowImage, forSegmentAt: 0)
        segment.setTitle(Title.noForSegment, forSegmentAt: 1)
        segment.setImage(markImage, forSegmentAt: 2)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var separatorView: UIView = createSeparator()
    
    // MARK: - DEADLINE VIEW
    lazy var deadlineView: UIView = createViewForStack()
    
    lazy var deadlineLabel: UILabel = UILabel.createLabel(font: Fonts.regular17, textLabel: Title.doneBy, textAlignment: .left, color: UIColor(named: "navTitle") ?? UIColor())
    
    lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "blueTitle"), for: .normal)
        button.titleLabel?.font = Fonts.semibold13
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var calendarSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    // MARK: - CALENDAR
    lazy var calendarView: UIView = createViewForStack()
    lazy var calendarSeparatorView: UIView = createSeparator()
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        picker.date = Date.tomorrow
        return picker
    }()
    
    lazy var stackView = UIStackView()
    // MARK: - UIButton
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainViews")
        button.setTitle(Title.delete, for: .normal)
        button.titleLabel?.font = Fonts.regular17
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "grayText"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupLayout()
        backgroundColor = UIColor(named: "background")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods for layout
    private func setupLayout() {
        navBarLayout()
        textViewLayout()
        createStack()
        setupPriorityViewLayout()
        setupDeadlineView()
        setupDatePickerView()
        setupLayoutButton()
    }
    // MARK: - navBarLayout
    private func navBarLayout() {
        addSubview(titleLabel)
        addSubview(cancelButton)
        addSubview(saveButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 108),
            cancelButton.heightAnchor.constraint(equalToConstant: 56),
            
            saveButton.topAnchor.constraint(equalTo: self.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 118),
            saveButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    // MARK: - textViewLayout
    private func textViewLayout() {
        addSubview(taskTextView)
        NSLayoutConstraint.activate([
            taskTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 72),
            taskTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            taskTextView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    // MARK: - setupStackView
    private func createStack() {
        stackView = UIStackView(arrangedSubviews: [priorityView, separatorView, deadlineView, calendarSeparatorView, calendarView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = UIColor(named: "mainViews")
        stackView.layer.cornerRadius = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: taskTextView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    // MARK: - setupPriorityViewLayout
    private func setupPriorityViewLayout() {
        priorityView.addSubview(priorityLabel)
        priorityView.addSubview(prioritySegment)
        NSLayoutConstraint.activate([
            priorityView.heightAnchor.constraint(equalToConstant: 56),
            priorityView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            //
            prioritySegment.topAnchor.constraint(equalTo: priorityView.topAnchor, constant: 10),
            prioritySegment.trailingAnchor.constraint(equalTo: priorityView.trailingAnchor, constant: -12),
            prioritySegment.widthAnchor.constraint(equalToConstant: 150),
            //
            priorityLabel.topAnchor.constraint(equalTo: priorityView.topAnchor, constant: 17),
            priorityLabel.leadingAnchor.constraint(equalTo: priorityView.leadingAnchor, constant: 16),
            //
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
        ])
    }
    // MARK: - setupDeadlineView
    private func setupDeadlineView() {
        deadlineView.addSubview(deadlineLabel)
        deadlineView.addSubview(dateButton)
        deadlineView.addSubview(calendarSwitch)
        
        NSLayoutConstraint.activate([
            //
            deadlineView.heightAnchor.constraint(equalToConstant: 58),
            //
            deadlineLabel.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: 16),
            deadlineLabel.topAnchor.constraint(equalTo: deadlineView.topAnchor, constant: 9),
            //
            dateButton.bottomAnchor.constraint(equalTo: deadlineView.bottomAnchor, constant: -4),
            dateButton.leadingAnchor.constraint(equalTo: deadlineLabel.leadingAnchor),
            //
            calendarSwitch.trailingAnchor.constraint(equalTo: deadlineView.trailingAnchor, constant: -12),
            calendarSwitch.topAnchor.constraint(equalTo: deadlineView.topAnchor, constant: 12.5)
        ])
    }
    // MARK: - setupDatePickerView
    private func setupDatePickerView() {
        calendarView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            //
            calendarView.heightAnchor.constraint(equalToConstant: 330),
            //
            calendarSeparatorView.heightAnchor.constraint(equalToConstant: 0.5),
            calendarSeparatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            calendarSeparatorView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            //
            datePicker.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 17),
            datePicker.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -16)
        ])
    }
    // MARK: - setupLayoutDeleteButton
    private func setupLayoutButton() {
        self.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    // MARK: Methods for same UI
    private func createViewForStack() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(named: "mainViews")
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(named: "separatorColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createNavButton(title: String, font: UIFont, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleEdgeInsets = UIEdgeInsets(top: 17, left: 16, bottom: 17, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
