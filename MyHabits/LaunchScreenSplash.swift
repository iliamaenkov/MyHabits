//
//  LaunchScreen.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 10.11.2023.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    //MARK: - UI Elements (Launch screen customization)
    
    private let logoImage: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return logoImageView
    }()
    
    private let appName: UILabel = {
        let appLabel = UILabel()
        appLabel.text = "MyHabit"
        appLabel.font = .SFProDisplaySemibold_Big
        appLabel.textColor = .purpleDark
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return appLabel
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
    }
    
    
    //MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoImage)
        view.addSubview(appName)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
            logoImage.heightAnchor.constraint(equalToConstant: 120),

            appName.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -42),
            appName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
