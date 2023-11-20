//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 01.11.2023.
//

import UIKit

protocol HabitsDelegate: AnyObject {
    func habitCreate()
    func reloadProgressBar()
}

extension HabitsViewController: HabitsDelegate, HabitDetailsDelegate {
    
    func habitCreate() {
        self.habitCollectionView.reloadData()
    }
    
    func habitDetailDelete(at index: Int) {
        self.habitCollectionView.deleteItems(at: [IndexPath(item: index, section: 1)])
        reloadProgressBar()
    }
    
    func reloadProgressBar() {
        self.habitCollectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
    }
    
    func habitDetailUpdate(habit: Habit, at index: Int) {
        self.habitCollectionView.reloadItems(at: [IndexPath(row: index, section: 1)])
    }
}

final class HabitsViewController: UIViewController {
    
    var store = HabitsStore.shared
    
    
    //MARK: - UI Elements
    
    ///CollectionView
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        return layout
    }()

    private lazy var habitCollectionView: UICollectionView = {
        let collectinView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectinView.translatesAutoresizingMaskIntoConstraints = false
        collectinView.showsVerticalScrollIndicator = false
        collectinView.backgroundColor = .lightGray
        
        return collectinView
    }()
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigation()
    }
    
    //MARK: - Private
    
    ///Navigation
    private func setupNavigation() {
        
        if let navigationController = navigationController {
            navigationController
                .setNavigationBarAppearance(
                    NavigationControllerManager
                        .shared
                        .navigationBarAppearance
                )
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewHabit(_:))
        )
        navigationItem.rightBarButtonItem?.tintColor = .purpleDark
        
        title = "Сегодня"
        tabBarItem.title = "Привычки"
    }
    
    ///UI setup
    private func setupUI() {
        view.addSubview(habitCollectionView)
        habitCollectionView.reloadData()
        
        habitCollectionView.dataSource = self
        habitCollectionView.delegate = self
        
        habitCollectionView.register(
            HabitCollectionViewCell.self,
            forCellWithReuseIdentifier: HabitCollectionViewCell.id
        )
        habitCollectionView.register(
            ProgressCollectionViewCell.self,
            forCellWithReuseIdentifier: ProgressCollectionViewCell.id
        )
    }

    ///Constraints
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            habitCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            habitCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            habitCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
        
    }

    //MARK: - Actions
    
    @objc private func addNewHabit(_ sender: Any) {

        let habitViewController = HabitViewController(habit: nil, index: nil)
        habitViewController.habitsDelegate = self
        
        let navigationController = UINavigationController(rootViewController: habitViewController)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }


}


