//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 08.11.2023.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    weak var progressBarUpdateDelegate: HabitsDelegate?
    
    private var currentHabit = Habit(name: "", date: Date(), color: UIColor())
    
    ///Identificator
    static let id = "HabitCell"
    
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
        button.setImage(largeBoldDoc, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
    
    //MARK: - Configure
    
    func setupUI() {
        contentView.backgroundColor = .white
        addSubview(counter)
        addSubview(habitTime)
        addSubview(habitTitle)
        addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(checkHabit), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            ///habitTitle constraints
            habitTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            habitTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),

            ///habitTime constraints
            habitTime.topAnchor.constraint(equalTo: habitTitle.bottomAnchor, constant: 16),
            habitTime.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),

            ///doneButton constraints
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            ///counter constraints
            counter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            counter.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    
    //MARK: - Actions
    
    func setupHabit(_ habit: Habit) {
         
         currentHabit = habit
         
        habitTitle.text = currentHabit.name
        habitTitle.textColor = currentHabit.color
         
        habitTime.text = currentHabit.dateString
         
        counter.text = "Счетчик \(currentHabit.trackDates.count)"
         
        doneButton.tintColor = currentHabit.color
         
         if currentHabit.isAlreadyTakenToday {
             setImageCheckButton("checkmark.circle.fill")
         }
     }
    
    private func setImageCheckButton(_ imageName: String) {
        doneButton.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func checkHabit() {
            
            if !currentHabit.isAlreadyTakenToday {
                
                HabitsStore.shared.track(currentHabit)
                HabitsStore.shared.save()
                
                setImageCheckButton("checkmark.circle.fill")
                counter.text = "Счётчик: \(currentHabit.trackDates.count)"
                
                self.progressBarUpdateDelegate?.reloadProgressBar()
            }
            
        }
    
}
