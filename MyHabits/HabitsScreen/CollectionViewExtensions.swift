//
//  Extensions.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 12.11.2023.
//

import UIKit

//MARK: - UICollectionViewDataSource Methods

extension HabitsViewController: UICollectionViewDataSource {
    
    ///numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    ///numberOfItemsInSection
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {

        return (section == 0) ? 1 : HabitsStore.shared.habits.count
    }
    

    ///cellForItemAt
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let indexSection = indexPath.section
        let indexRow = indexPath.row
        
        if indexSection == 0 {
            ///Configure and return the cell for progress
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProgressCollectionViewCell.id,
                for: indexPath
            ) as! ProgressCollectionViewCell
            
            let todayProgress = HabitsStore.shared.habits.count > 0 ? HabitsStore.shared.todayProgress: 0.0
            cell.setupProgress(todayProgress)
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 12
            
            return cell
            
        } else {
            ///Configure and return the cell for the habit
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HabitCollectionViewCell.id,
                for: indexPath
            ) as! HabitCollectionViewCell
            
            cell.progressBarUpdateDelegate = self
            cell.setupHabit(HabitsStore.shared.habits[indexRow])
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 12
            
            return cell
        }
    }

}

//MARK: - UICollectionViewDelegate Methods

extension HabitsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section > 0 {
            let habitDetailsViewController = HabitDetailsViewController(index: indexPath.row)
            habitDetailsViewController.habitDetailsDelegate = self
            navigationController?.pushViewController(habitDetailsViewController, animated: false)
            
        }
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Methods
    
extension HabitsViewController: UICollectionViewDelegateFlowLayout {

    ///Cell size
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return indexPath.section == 0
        ?
        CGSize(width: collectionView.bounds.width - 16, height: 60)
        : 
        CGSize(width: collectionView.bounds.width - 16, height: 130)
    }
    
    ///insets
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return section == 0
        
        ? UIEdgeInsets(
            top: 22,
            left: 0,
            bottom: 6,
            right: 0)
        : UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0
        )
    }
 
}
