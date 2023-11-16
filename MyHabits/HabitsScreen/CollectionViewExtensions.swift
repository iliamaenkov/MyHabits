//
//  Extensions.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 12.11.2023.
//

import UIKit

    //MARK: HabitsViewController - Extensions

extension HabitsViewController: UICollectionViewDataSource {
    
    //MARK: - UICollectionViewDataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        } else {
            return HabitsStore.shared.habits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            // Configure and return the cell for the first section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.id, for: indexPath) as! ProgressCollectionViewCell
            
            let todayProgress = HabitsStore.shared.todayProgress
            cell.setup(with: todayProgress)
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 12
            
            return cell
        } else {
            // Configure and return the cell for the second section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.id, for: indexPath) as! HabitCollectionViewCell
            
            let habit = HabitsStore.shared.habits[indexPath.item]
            cell.setup(with: habit)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 12
            
            return cell
        }
    }

}

extension HabitsViewController: UICollectionViewDelegate {
    
    //MARK: - UICollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.section != 0 else {
            return
        }
        
            let habit = HabitsStore.shared.habits[indexPath.item]
            
            // Create an instance of HabitEditViewController
            let habitEditViewController = HabitEditViewController()
            habitEditViewController.habit = habit
            
            let navigationController = UINavigationController(rootViewController: habitEditViewController)
            navigationController.modalTransitionStyle = .coverVertical
            navigationController.modalPresentationStyle = .fullScreen
            
            
            present(navigationController, animated: true, completion: nil)
        
    }
}

    
extension HabitsViewController: UICollectionViewDelegateFlowLayout {

    //MARK: - UICollectionViewDelegateFlowLayout Methods

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if indexPath.section == 0 {
            let width = collectionView.bounds.width - 16
            let height: CGFloat = 60
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.bounds.width - 16
            let height: CGFloat = 130
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            // Отступы для первой секции
            return UIEdgeInsets(top: 22, left: 0, bottom: 6, right: 0)
        } else {
            // Отступы для остальных секций
            return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        }
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        // Расстояние между ячейками внутри секции
//        return section == 0 ? 12 : 18
//    }
}
