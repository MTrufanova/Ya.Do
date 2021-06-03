//
//  StartViewController.swift
//  Ya.Do
//
//  Created by msc on 03.06.2021.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {

    lazy var startImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "startIcon")
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2039215686, green: 0.2, blue: 0.2, alpha: 1)
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    
    lazy var releaseLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2039215686, green: 0.2, blue: 0.2, alpha: 1)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8705882353, blue: 0.3490196078, alpha: 1)
        setupLayout()
        setupAboutLabels()
    }
    
    func setupAboutLabels() {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {return}
        releaseLabel.text = "Версия \(version)"
        
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
        nameLabel.text = appName
    }

    private func setupLayout() {
        view.addSubview(startImageView)
        view.addSubview(nameLabel)
        view.addSubview(releaseLabel)
        
        startImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(startImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        releaseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }

}
