//
//  StartViewController.swift
//  Ya.Do
//
//  Created by msc on 03.06.2021.
//

import UIKit

class StartViewController: UIViewController {

    lazy var startImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "startIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "startButton")
        label.font = Fonts.heavy20
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var releaseLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "startButton")
        label.font = Fonts.regular16
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create task", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor(named: "startButton")
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushTaskVC), for: .touchUpInside)
        return button
    }()
    private var portretConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8705882353, blue: 0.3490196078, alpha: 1)
        setupLayout()
        setupAboutLabels()
        NSLayoutConstraint.activate(portretConstraints)
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate(portretConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(portretConstraints)
            NSLayoutConstraint.deactivate(landscapeConstraints)
        }
    }
    func setupAboutLabels() {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {return}
        let textVersion = NSLocalizedString("version", comment: "")
        releaseLabel.text = "\(textVersion) \(version)"
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
        nameLabel.text = appName
    }

    @objc func pushTaskVC() {
        let taskVC = DetailTaskViewController()
        taskVC.modalPresentationStyle = .formSheet
        self.present(taskVC, animated: true, completion: nil)
    }

    private func setupLayout() {
        view.addSubview(startImageView)
        view.addSubview(nameLabel)
        view.addSubview(releaseLabel)
        view.addSubview(startButton)

        portretConstraints.append(contentsOf: [
            startImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startImageView.heightAnchor.constraint(equalToConstant: 200),
            startImageView.widthAnchor.constraint(equalToConstant: 200),

            nameLabel.topAnchor.constraint(equalTo: startImageView.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            releaseLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            releaseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 55),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])

        landscapeConstraints.append(contentsOf: [
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 55),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),

            releaseLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -8),
            releaseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameLabel.bottomAnchor.constraint(equalTo: releaseLabel.topAnchor, constant: -8),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            startImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),
            startImageView.heightAnchor.constraint(equalToConstant: 200),
            startImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
