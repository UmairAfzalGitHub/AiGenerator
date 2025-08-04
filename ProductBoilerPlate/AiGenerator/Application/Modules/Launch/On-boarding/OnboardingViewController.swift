//
//  OnboardingScreenViewController.swift
//  PhotoRecovery
//
//  Created by Haider on 27/12/2024.
//

import UIKit
import Photos
import StoreKit

class OnBoarding {
    
    var topImage = UIImage()
    var heading = ""
    var description = ""
    
    init(image: UIImage, heading: String, description: String) {
        topImage = image
        self.heading = heading
        self.description = description
    }
}

class OnboardingViewController: UIViewController,
                                UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    
    // Flag to track if review prompt has been shown
    private var hasShownReviewPrompt = false

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    var dataSource: [OnBoarding] = [
        OnBoarding(image: UIImage(named: "on-boarding-1")!,
                   heading: "Connect Photo Recovery to your Camera Roll",
                   description: "To recover your deleted photos and videos, we will need your permission."),
        OnBoarding(image: UIImage(named: "on-boarding-2")!,
                   heading: "Recover your Photos & Video",
                   description: "Recover old and deleted photos and videos seemlessly with this app."),
        OnBoarding(image: UIImage(named: "on-boarding-3")!,
                   heading: "Help keep it free",
                   description: "Show your love and help support Photo Recovery by leaving us a review on the App Store.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        if UIDevice().isSmallerDevice() {
            stackViewTopConstraint.constant = -16
            stackViewBottomConstraint.constant = 0
        }
    }
    
    //MARK: - Private Methods
    func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
        nextButton.layer.cornerRadius = 12
        skipButton.layer.cornerRadius = 12
        
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        // Configure collection view for proper horizontal scrolling
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
        
        // Disable scrolling indicators
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        // Prevent manual scrolling but allow programmatic scrolling
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
    }

    func finishOnboarding() {
        UserDefaultManager.shared.setValue(.onBoarding(true))
        AdManager.shared.adCounter = RemoteConfigManager.shared.maxInterstitalAdCounter
        AdManager.shared.showInterstitial(adId: AdMobConfig.interstitial) {
            let controller = HomeViewContoller()
            UIApplication.shared.updateRootViewController(to: controller)
        }
    }

    //MARK: - IBActions
    @IBAction func didTapNextButton(_ sender: Any) {
        // Get the current page index based on content offset
        let currentIndex = getCurrentPageIndex()
        
        let nextIndex = currentIndex + 1
        let reviewEnabled = RemoteConfigManager.shared.onboardingReviewEnabled
        print("Current index: \(currentIndex), Next index: \(nextIndex), Review enabled: \(reviewEnabled)")
        
        switch currentIndex {
        case 0: // soft permission for photo access
            requestPhotoLibraryAccess()
            
        case 1: // second screen
            if !reviewEnabled {
                // If review is disabled, finish onboarding after the second screen
                print("Review disabled, finishing onboarding after second screen")
                finishOnboarding()
            } else {
                // Otherwise proceed to the third screen
                scrollToNextItem()
            }
            
        case 2: // last screen - request app review
            if hasShownReviewPrompt {
                // If we've already shown the review prompt, finish onboarding
                finishOnboarding()
            } else {
                // Otherwise, show the review prompt
                requestAppStoreReview()
            }
            
        default:
            scrollToNextItem()
        }
    }
    
    // Helper method to determine the current page index reliably on all devices
    private func getCurrentPageIndex() -> Int {
        let pageWidth = collectionView.frame.width
        let contentOffsetX = collectionView.contentOffset.x
        
        // Calculate the current page index based on content offset
        let currentPage = Int(round(contentOffsetX / pageWidth))
        
        // Ensure the index is within bounds
        return max(0, min(currentPage, dataSource.count - 1))
    }
    
    @IBAction func didTapSkipButton(_ sender: Any) {
        finishOnboarding()
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = OnBoardingCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        
        // Check if this is the last cell in the dataSource
        let isLastCell = indexPath.item == dataSource.count - 1
        
        // Pass the isLastCell parameter to the setupCell method
        cell.setupCell(data: dataSource[indexPath.item], isLastCell: isLastCell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        guard let visibleIndexPath = collectionView.indexPathForItem(at: CGPoint(x: visibleRect.midX, y: visibleRect.midY)) else {
            return
        }
//        skipButton.isHidden = visibleIndexPath.item == dataSource.count - 1
    }
    
    private func requestPhotoLibraryAccess() {
        // Request access for both reading and writing
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    // User granted full access
                    print("Full access granted")
                    self.accessGranted()
                    
                case .limited:
                    // User granted limited access (iOS 14+)
                    print("Limited access granted")
                    self.limitedAccessGranted()
                    
                case .denied, .restricted:
                    // User denied access or it's restricted by parental controls
                    print("Access denied")
                    self.showAccessDeniedAlert()
                    
                case .notDetermined:
                    // This shouldn't happen after requesting, but just in case
                    print("Access not determined")
                    
                @unknown default:
                    print("Unknown authorization status")
                }
            }
        }
    }

    private func accessGranted() {
        scrollToNextItem()
    }

    private func limitedAccessGranted() {
        scrollToNextItem()
    }

    private func showAccessDeniedAlert() {
        let alert = CustomAlertViewController(title: "Photo Access Required",
                                             description: "To recover your deleted photos, please allow access to your photo library in Settings.",
                                             okText: "Settings",
                                             alertType: .confirmation)
        
        alert.onCancel = {
            self.scrollToNextItem()
        }

        alert.onOkay = {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        present(alert, animated: true)
    }
    
    private func scrollToNextItem() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            guard let visibleIndexPath = self.collectionView.indexPathsForVisibleItems.first else {
                return
            }
            
            let nextIndex = visibleIndexPath.item + 1
            let reviewEnabled = RemoteConfigManager.shared.onboardingReviewEnabled
            
            print("Attempting to scroll from index \(visibleIndexPath.item) to index \(nextIndex)")
            print("onboardingReviewEnabled: \(reviewEnabled)")
            
            // Check if we're on the second screen (index 1) and review is disabled
            if visibleIndexPath.item == 1 && !reviewEnabled {
                // Skip the third screen and finish onboarding
                print("Review screen disabled, finishing onboarding")
                self.finishOnboarding()
                return
            }

            if nextIndex < self.dataSource.count {
                // Try a more direct approach to scrolling
                // Set content offset directly instead of using scrollToItem
                let pageWidth = self.collectionView.frame.width
                let newOffset = CGPoint(x: pageWidth * CGFloat(nextIndex), y: 0)
                
                print("Setting content offset to: \(newOffset)")
                
                // Use animated scrolling with UIView animation
                UIView.animate(withDuration: 0.3) {
                    self.collectionView.contentOffset = newOffset
                }
            } else {
                self.finishOnboarding()
            }
        })
    }
    
    // MARK: - App Store Review
    private func requestAppStoreReview() {
        // Set the flag to indicate we've shown the review prompt
        hasShownReviewPrompt = true
        
        // Request review using StoreKit
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
