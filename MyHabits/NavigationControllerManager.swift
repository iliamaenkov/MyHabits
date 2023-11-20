//
//  NavigationControllerManager.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 13.11.2023.
//

import UIKit

//MARK: - NavigationController appearance

class NavigationControllerManager {
    
    static let shared = NavigationControllerManager()
    
    let navigationBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        return appearance
    }()
}

//MARK: - Extensions

extension UINavigationController {
    func setNavigationBarAppearance(_ appearance: UINavigationBarAppearance) {
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
