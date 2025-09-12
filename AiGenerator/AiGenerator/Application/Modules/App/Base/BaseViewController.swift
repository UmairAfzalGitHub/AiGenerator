//
//  BaseViewController.swift
//  Photo Recovery
//
//  Created by Umair Afzal on 07/03/2025.
//

import Foundation
import UIKit
import IOS_Helpers
import GoogleMobileAds

enum CellCorner {
    case bottom
    case all
}

class BaseViewController: UIViewController, IAPOnboardingViewControllerDelegate, IAPViewControllerDelegate {

    private var loaderVC: LoaderViewController?
    private var bannerAdId: AdMobId?
    var iapVC: UIViewController?
    
    let customNavigationBar: AppNavigationBar = {
        let navigationBar = AppNavigationBar()
        navigationBar.backgroundColor = .green
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    var bannerAdView: BannerView? {
        didSet {
            if let AdId = bannerAdId, !IAPManager.shared.isUserSubscribed {
                AdManager.shared.loadbannerAd(adId: AdId, bannerView: bannerAdView, root: self)
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        view.backgroundColor = .black
        setupNavigationBar()
        setupStandardBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("✅✅ viewWillAppear: \(String(describing: self))✅✅")
        //AdManager.shared.loadbannerAd(bannerView: bannerAdView, root: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("✅✅ viewWillDisappear: \(String(describing: self))✅✅")
    }
    
    deinit { print("DE-INIT: \(self)") }
    
    func style() {}
    
    func setup() {}
    
    func setupBanner(adId: AdMobId) {
        bannerAdId = adId
    }
    
    func showIAP() {
        let iapView = IAPViewController()
        iapView.delegate = self
        iapVC = iapView

        iapVC?.modalPresentationStyle = .fullScreen
        iapVC?.modalTransitionStyle = .coverVertical
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.present(self.iapVC ?? UIViewController(), animated: true, completion: nil)
        })
    }
    
    func hideCustomNavigationBar() {
        customNavigationBar.isHidden = true
    }
    
    func cellsForRounding(contentView: UIView,
                          customSeperator: UIView? = nil,
                          indexPath: IndexPath,
                          tableView: UITableView,
                          corner: CellCorner) {
        
                
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        switch corner {
        case .bottom:
            if isLast {
                contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                customSeperator?.isHidden = true
                contentView.layer.shadowColor = UIColor.black.cgColor
                contentView.layer.shadowOpacity = 1
                contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
                contentView.layer.shadowRadius = 8
                
            } else {
                contentView.layer.cornerRadius = 0
                contentView.layer.maskedCorners = []
                contentView.layer.shadowOpacity = 0
                contentView.layer.masksToBounds = true
            }
        case .all:
            if isFirst || isLast {
                if isFirst {
                    contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                }
                if isLast {
                    contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                    customSeperator?.isHidden = true
                    contentView.layer.shadowColor = UIColor.black.cgColor
                    contentView.layer.shadowOpacity = 1
                    contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
                    contentView.layer.shadowRadius = 8
                }
            } else {
                contentView.layer.cornerRadius = 0
                contentView.layer.maskedCorners = []
                contentView.layer.shadowOpacity = 0
                contentView.layer.masksToBounds = true
            }
        }
    }

    func addLeftNexusView() {
        let imageView = UIImageView(image: UIImage(named: "navBar-vpn"))
        imageView.contentMode = .scaleAspectFit
        customNavigationBar.setLeftCustomView(imageView)
    }
    
    func addBackButton() {
        let imageView = UIImageView(image: UIImage(named: "back-arrow"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackButton))
        imageView.addGestureRecognizer(tapGesture)
        customNavigationBar.setLeftCustomView(imageView)
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showCustomAlert(title: String = "Success", message: String, alertType: CustomAlertType = .success, completion: (() -> Void)? = nil) {
        var titleString = title
        if alertType == .error {
            titleString = "Error"
        }
        let alert = CustomAlertViewController(title: titleString,
                                             description: message,
                                             okText: "Okay",
                                              alertType: alertType)
        alert.onOkay = completion
        present(alert, animated: true)
    }
    
    /// Sets up a standard back button with just an arrow icon
    func setupStandardBackButton() {
        // Only set up back button if this is not the root view controller
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            // Hide the default back button
            navigationItem.hidesBackButton = true
            
            // Create a standard back button with just the arrow
            let backButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(didTapBackButton)
            )
            backButton.tintColor = .white
            
            // Remove any text from the back button
            navigationItem.backButtonTitle = ""
            
            // Set as left bar button item
            navigationItem.leftBarButtonItem = backButton
        }
    }
    

    
    func showLoader(duration: TimeInterval = 1.0, completion: @escaping () -> Void) {
        let loader = LoaderViewController()
        loader.modalPresentationStyle = .overFullScreen
        loader.modalTransitionStyle = .crossDissolve
        self.loaderVC = loader  // Keep a strong reference
        self.topMostViewController().present(loader, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.loaderVC?.dismiss(animated: true) {
                    self?.loaderVC = nil
                    completion()
                }
            }
        }
    }
    
    /// Shows a loader with manual control for hiding it
    /// - Parameters:
    ///   - animation: The name of the animation to show
    ///   - completion: Completion handler called after the loader is presented
    func showLoaderWithManualDismissal(animation: String, completion: @escaping () -> Void) {
        let loader = LoaderViewController()
        loader.animationName = animation
        loader.modalPresentationStyle = .overFullScreen
        loader.modalTransitionStyle = .crossDissolve
        self.loaderVC = loader  // Keep a strong reference
        self.topMostViewController().present(loader, animated: true) {
            completion()
        }
    }
    
    /// Hides the currently displayed loader
    /// - Parameter completion: Completion handler called after the loader is dismissed
    func hideLoader(completion: (() -> Void)? = nil) {
        guard let loaderVC = self.loaderVC else {
            completion?()
            return
        }
        
        loaderVC.dismiss(animated: true) {
            self.loaderVC = nil
            completion?()
        }
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        guard let window = UIApplication.shared.sceneWindow else { return }

        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.appGreenMedium
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 17)
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let textSize = toastLabel.intrinsicContentSize
        let padding: CGFloat = 16
        toastLabel.frame = CGRect(
            x: (window.frame.width - textSize.width - padding) / 2,
            y: window.frame.height - 100,
            width: textSize.width + padding,
            height: textSize.height + padding / 2
        )

        window.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    //MARK: - IAPViewControllerDelegate
    func performAction() {
        print("Perform IAP Action")
    }
    
    func cancelAction() {
        print("Cancel IAP Action")
    }
    
    func setupNavigationBar() {
        // Set navigation bar background color to match the design
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black // Dark background as shown in image
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Remove the bottom border/shadow - THIS IS THE KEY PART YOU'RE MISSING
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        // Additional border removal for older iOS versions
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Hide the default back button
        navigationItem.hidesBackButton = true
        
        // Create left side with help button
        let helpButton = createRoundButton(
            systemImage: "questionmark",
            action: #selector(didTapHelp)
        )
        
        // Create right side with crown and menu buttons
        let crownButton = createRoundButton(
            systemImage: "crown.fill",
            action: #selector(didTapMembership)
        )
        
        let menuButton = createRoundButton(
            systemImage: "line.3.horizontal",
            action: #selector(didTapMenu)
        )
        
        // Set navigation bar items
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: helpButton)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: menuButton),
            UIBarButtonItem(customView: crownButton)
        ]
    }

    private func createRoundButton(systemImage: String, action: Selector) -> UIView {
        // Create container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 22
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        // Create image view
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: systemImage)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        // Add image to container
        containerView.addSubview(imageView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 44),
            containerView.heightAnchor.constraint(equalToConstant: 44),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return containerView
    }

    // MARK: - Navigation Button Actions
    @objc private func didTapHelp() {
        // Handle help button tap
        print("Help button tapped")
        let helpVC = HelpViewController()
        tabBarController?.present(helpVC, animated: true)
    }

    @objc private func didTapMenu() {
        // Handle menu button tap
        print("Menu button tapped")
        // You can add your menu functionality here
    }
    
    @objc func didTapMembership() {
        print("IAP button tapped")
        // You can add your menu functionality here
    }
}
