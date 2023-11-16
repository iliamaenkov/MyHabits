//
//  InfoViewController.swift.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 01.11.2023.
//

import UIKit

final class InfoViewController: UIViewController {
    
    static let infoIdent = "Информация"
    
    //MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Привычка за 21 день"
        title.textColor = .black
        title.font = .SFProDisplaySemibold_Big
        return title
    }()
    
    private let textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = infoText
        text.textColor = .black
        text.font = .SFProTextRegular_Big
        text.numberOfLines = 0
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigation()
    }
    
    
    //MARK: - Private
     
    private func setupNavigation() {
        navigationController?.navigationBar.standardAppearance = 
        AppearanceManager.shared.navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = 
        AppearanceManager.shared.navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = 
        AppearanceManager.shared.navigationBarAppearance
        
        navigationController?.navigationBar.tintColor = .systemBackground
        
        title = "Информация"
    }
    
     private func setupUI() {
         
         view.backgroundColor = UIColor.white
         view.addSubview(scrollView)
         scrollView.addSubview(titleLabel)
         scrollView.addSubview(textLabel)
         
     }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),

            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            textLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

}
