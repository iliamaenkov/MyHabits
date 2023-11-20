//
//  SceneDelegate.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 01.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let launchScreenViewController = LaunchScreenViewController()
        
        window.rootViewController = launchScreenViewController
        
        window.makeKeyAndVisible()
        self.window = window
        self.window?.overrideUserInterfaceStyle = .light
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showMainApp()
        }
    }
    
    func showMainApp() {
        window?.rootViewController = createTabBarController()
    }
}

    //MARK: - Private

    private func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        
        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)
        
        setTabBarBadgeAppearance(appearance.stackedLayoutAppearance)
        setTabBarBadgeAppearance(appearance.inlineLayoutAppearance)
        setTabBarBadgeAppearance(appearance.compactInlineLayoutAppearance)
        
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        tabBarController.tabBar.isTranslucent = false
        
        tabBarController.viewControllers = (0...1)
            .map { index in
                let viewController: UIViewController
                let imageName: String
                let title: String
                
                if index == 0 {
                    viewController = HabitsViewController()
                    imageName = "rectangle.grid.1x2.fill"
                    title = "Привычки"
                } else {
                    viewController = InfoViewController()
                    imageName = "info.circle.fill"
                    title = "Информация"
                }
                
                viewController.tabBarItem.image = UIImage(systemName: imageName)
                viewController.title = title
                
                return UINavigationController(rootViewController: viewController)
            }
        
        
        return tabBarController
    }


    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .systemGray
        itemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.paragraphStyle: NSParagraphStyle.default
        ]
        
        itemAppearance.selected.iconColor = .purpleDark
        itemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.purpleDark,
            NSAttributedString.Key.paragraphStyle: NSParagraphStyle.default
        ]
        
    }

    private func setTabBarBadgeAppearance(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.badgeBackgroundColor = .systemRed
        itemAppearance.normal.badgeTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemRed
        ]
    }

