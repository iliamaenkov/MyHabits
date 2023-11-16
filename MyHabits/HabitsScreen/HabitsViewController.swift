//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 01.11.2023.
//

import UIKit

final class HabitsViewController: UIViewController {
    
    static let hibitsIdent = "Привычки"
    
    //MARK: - UI Elements
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
    
        return layout
    }()

    lazy var habitCollectionView: UICollectionView = {
        let collectinView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectinView.translatesAutoresizingMaskIntoConstraints = false
        collectinView.backgroundColor = .lightGray
        collectinView.register(
            HabitCollectionViewCell.self,
            forCellWithReuseIdentifier: HabitCollectionViewCell.id
        )
        collectinView.contentInset = UIEdgeInsets(top: 18, left: 16, bottom: 12, right: 16)
        
        return collectinView
    }()
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigation()
        
        habitCollectionView.dataSource = self
        habitCollectionView.delegate = self
        habitCollectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.id)
    }
    
    //MARK: - Private
    
    private func setupNavigation() {
        navigationController?.navigationBar.standardAppearance = 
        AppearanceManager.shared.navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = 
        AppearanceManager.shared.navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = 
        AppearanceManager.shared.navigationBarAppearance
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewHabit(_:))
        )
        navigationItem.rightBarButtonItem?.tintColor = .purpleDark
        
        navigationController?.navigationBar.tintColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Сегодня"
        tabBarItem.title = "Привычки"
        
    }
    
    private func setupUI() {
        view.addSubview(habitCollectionView)
    }

    
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

        let habitViewController = HabitViewController()
        habitViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: habitViewController)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true, completion: nil)
    }


}


//MARK: - Extensions

extension HabitsViewController: HabitViewControllerDelegate {
    
    func habitViewControllerDidCancel(_ habitViewController: HabitViewController) {
        habitViewController.dismiss(animated: true, completion: nil)
    }
    
    func habitViewControllerDidSave(_ habitViewController: HabitViewController, with habit: Habit) {
        let store = HabitsStore.shared
        store.habits.append(habit)
        
        if Thread.isMainThread {
            // Update UI directly
            let indexPath = IndexPath(item: store.habits.count - 1, section: 0)
            habitCollectionView.insertItems(at: [indexPath])
        } else {
            // Dispatch UI update to the main thread
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: store.habits.count - 1, section: 0)
                self.habitCollectionView.insertItems(at: [indexPath])
            }
        }
        // Dismiss the view controller
        habitViewController.dismiss(animated: true, completion: nil)
    }
}

