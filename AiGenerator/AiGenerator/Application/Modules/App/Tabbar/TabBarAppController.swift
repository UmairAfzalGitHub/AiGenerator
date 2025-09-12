
import Foundation
import UIKit

class TabBarAppController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .clear
        setupTabBarController()
        
        // Restore the previously selected tab
//        let previouslySelectedIndex = TabSelectionManager.shared.getSelectedTab()
//        self.selectedIndex = previouslySelectedIndex == AppTabBars.settings.rawValue ? 0 : previouslySelectedIndex
    }
    
    private func setupTabBarController() {
        if #available(iOS 18.0, *) {
            traitOverrides.horizontalSizeClass = .compact
        }
        
        var controllers: [UIViewController] = []
        AppTabBars.allCases.forEach { tabBar in
            controllers.append(createNavController(title: tabBar.title(),
                                                             image: tabBar.image,
                                                             selectedImage: tabBar.selectedImage,
                                                             viewController: tabBar.controller))
        }
        
        self.viewControllers = controllers
        self.selectedIndex = 0
        
        // Appearance setup (same as before)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = UIColor(white: 0.2, alpha: 1)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray // unselected color
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.appPrimary // selected color
        ]
        
        if !UIDevice().hasNotch {
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
            appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        }
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func createNavController(title: String,
                                     image: UIImage,
                                     selectedImage: UIImage,
                                     viewController: UIViewController) -> UIViewController {
        
        viewController.title = nil
        viewController.navigationItem.title = ""
        
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        if !UIDevice().hasNotch {
            tabBarItem.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
        }
        viewController.tabBarItem = tabBarItem
        
        let navController = UINavigationController(rootViewController: viewController)
        
        // Navigation bar consistent appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        navController.navigationBar.compactAppearance = appearance
        
        return navController
    }
    
    func localize() {
        self.tabBar.items?[0].title = AppTabBars.aging.title()
        self.tabBar.items?[1].title = AppTabBars.generate.title()
        self.tabBar.items?[2].title = AppTabBars.babygallery.title()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
//    // Save the selected tab index when it changes
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        TabSelectionManager.shared.saveSelectedTab(index: tabBarController.selectedIndex)
//    }
}

fileprivate enum AppTabBars: Int, CaseIterable {
    case aging
    case generate
    case babygallery
    
    func title() -> String {
        switch self {
        case .aging:
            "Aging"
        case .generate:
            "Generate"
        case .babygallery:
            "Baby Gallery"
        }
    }
    
    var image: UIImage {
        switch self {
        case .aging:
            return UIImage(systemName: "hourglass")!.scaled(to: CGSize(width: 22, height: 22))
        case .generate:
            return UIImage(systemName: "figure.yoga")!.scaled(to: CGSize(width: 22, height: 22)).withTintColor(.appPrimary)
        case .babygallery:
            return UIImage(systemName: "photo.stack")!.scaled(to: CGSize(width: 22, height: 22)).withTintColor(.appPrimary)
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .aging:
            return UIImage(systemName: "hourglass")!.scaled(to: CGSize(width: 24, height: 24)) .withRenderingMode(.alwaysOriginal).withTintColor(.appPrimary)
        case .generate:
            return UIImage(systemName: "figure.yoga")!.scaled(to: CGSize(width: 24, height: 24)) .withRenderingMode(.alwaysOriginal).withTintColor(.appPrimary)
        case .babygallery:
            return UIImage(systemName: "photo.stack")!.scaled(to:CGSize(width: 24, height: 24)) .withRenderingMode(.alwaysOriginal).withTintColor(.appPrimary)
        }
    }
    
    var controller: UIViewController {
        switch self {
        case .aging:
            return AgingViewController()
        case .generate:
            return HomeViewContoller()
        case .babygallery:
            return BabyGalleryViewController()
        }
    }
}
