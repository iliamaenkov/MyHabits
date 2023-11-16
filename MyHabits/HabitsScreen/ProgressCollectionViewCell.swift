//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 11.11.2023.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    ///Identificator
    static let id = "ProgressCell"
    
    private let progressView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Все получится!"
        label.font = .SFProTextSemibold_Medium
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .SFProTextSemibold_Medium
        label.textColor = .systemGray
        label.text = "0%"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.5
        progressView.progressTintColor = .purpleDark
        progressView.layer.cornerRadius = 3.5
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        addSubview(titleLabel)
        addSubview(progressLabel)
        addSubview(progressBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            progressBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            progressBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            progressBar.heightAnchor.constraint(equalToConstant: 7),
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            progressLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
        ])
    }

    
    //MARK: - Action
    
    func setupProgress(_ percent: Float) {
        progressBar.setProgress(percent, animated: true)
        titleLabel.text = (percent == 0.0) ? "Добавьте первую привычку" : "\(Int(percent * 100))%"
        progressLabel.text = (percent == 1.0) ? "На сегодня всё!": "Всё получится!"
    }
    
    
}
