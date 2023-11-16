//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 08.11.2023.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    static let id = "HabitCell"
    
    var habit: Habit? {
         didSet {
             updateUI()
         }
     }
    
    //MARK: - Properties
    
    private let habitTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .SFProTextSemibold_Big
        return label
    }()
    
    private let habitTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .SFProTextRegular_Medium
        label.textColor = .systemGray
        
        return label
    }()
    
    private let counter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .SFProTextRegular_Low
        label.textColor = .systemGray2
        label.text = "Счетчик: 0"
        
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        
        let largeConfig = UIImage.SymbolConfiguration(
            pointSize: 32,
            weight: .light,
            scale: .large
        )
        let largeBoldDoc = UIImage(
            systemName: "circle",
            withConfiguration: largeConfig
        )
        let largeBoldDocFill = UIImage(
            systemName: "checkmark.circle.fill",
            withConfiguration: largeConfig
        )
        
        button.setImage(largeBoldDoc, for: .normal)
        button.setImage(largeBoldDocFill, for: .selected)
        button.tintColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        

        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func updateUI() {
//        guard let habit = habit else {
//            return
//        }
        
//        habitTitle.text = habit.name
//        habitTime.text = habit.dateString
        
    }
    
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(counter)
        contentView.addSubview(habitTime)
        contentView.addSubview(habitTitle)
        contentView.addSubview(doneButton)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            /// habitTitle constraints
            habitTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            habitTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            /// habitTime constraints
            habitTime.topAnchor.constraint(equalTo: habitTitle.bottomAnchor, constant: 16),
            habitTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            /// doneButton constraints
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
//            doneButton.widthAnchor.constraint(equalToConstant: 40),
//            doneButton.heightAnchor.constraint(equalToConstant: 40)
            counter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            counter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])

    }
    
    //MARK: - Actions
    
    
    func setup(with habit: Habit) {
        habitTitle.text = habit.name
        habitTime.text = habit.dateString
//        doneButton.isEnabled = true
        doneButton.tintColor = habit.color
        habitTitle.textColor = habit.color
 
    }
    
    @objc func doneButtonTapped() {
        doneButton.isSelected.toggle()
    }
}
