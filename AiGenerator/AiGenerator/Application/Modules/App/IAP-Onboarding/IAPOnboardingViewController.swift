//
//  IAPViewController.swift
//  GhostVPN
//
//  Created by Haider on 11/11/2024.
//

import UIKit
import Lottie
import StoreKit

protocol IAPOnboardingViewControllerDelegate {
    func performAction()
    func cancelAction()
}

class IAPOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private var monthlyProduct: SKProduct?
    private var yearlyProduct: SKProduct?
    var delegate: IAPOnboardingViewControllerDelegate?
    
    private var selectedPlan: PlanType = .monthly
    
    enum PlanType {
        case weekly, monthly
    }
    
    // MARK: - Looping Image Properties
    private lazy var loopingImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var scrollingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iap-looping-image")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iap-looping-image")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var thirdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iap-looping-image")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private var scrollingViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iap-background-gradient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleStartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimary
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleCenterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PRO"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleEndLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Access"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
      
    private lazy var featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var weeklyPlanView: PlanView = {
        let view = PlanView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(title: "Weekly Premium", price: "Loading...", period: "week")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(weeklyPlanTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var monthlyPlanView: PlanView = {
        let view = PlanView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(title: "Monthly Premium", price: "Loading...", period: "month")
        view.setSelected(true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(monthlyPlanTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var continueButton: GradientButton = {
        let button = GradientButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear  // Set to clear since we're using gradient
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var limitedAccessButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue with Limited Access", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.appPrimary.withAlphaComponent(0.8), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.1).cgColor
        button.addTarget(self, action: #selector(limitedAccessButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var autoRenewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Auto renewal, can be canceled anytime from the App Store."
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .textSecondary
        return label
    }()
    
    private lazy var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Restore Purchases", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.appPrimary, for: .normal)
        button.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var termsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Terms", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.textSecondary, for: .normal)
        button.addTarget(self, action: #selector(termsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Privacy", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.textSecondary, for: .normal)
        button.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var manageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Manage", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.textSecondary, for: .normal)
        button.addTarget(self, action: #selector(manageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
    
    var timer: Timer?
    var currentValue = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startCounting()
        setupUI()
        setupLoopingImages()
        setupConstraints()
        setupFeatures()
        setupIAP()
        localize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLoopingAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollingView.layer.removeAllAnimations()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(loopingImageContainer)
        contentView.addSubview(backgroundImageView)
        
        // Add looping image container at the top
        
        // Add other UI elements
//        contentView.addSubview(descriptionLabel)
        contentView.addSubview(titleStackView)
        contentView.addSubview(featuresStackView)
        contentView.addSubview(weeklyPlanView)
        contentView.addSubview(monthlyPlanView)
        contentView.addSubview(autoRenewLabel)
        contentView.addSubview(limitedAccessButton)
        contentView.addSubview(restoreButton)
        contentView.addSubview(footerStackView)
        
        view.addSubview(continueButton)
        view.addSubview(autoRenewLabel)

        titleStackView.addArrangedSubview(titleStartLabel)
        titleStackView.addArrangedSubview(titleContentView)
        titleStackView.addArrangedSubview(titleEndLabel)
        
        titleContentView.addSubview(titleCenterLabel)
        
        footerStackView.addArrangedSubview(termsButton)
        footerStackView.addArrangedSubview(manageButton)
        footerStackView.addArrangedSubview(privacyButton)
        
        view.addSubview(loadingIndicator)
        view.addSubview(loadingView)
        loadingView.addSubview(loadingLabel)
    }
    
    func startCounting() {
        currentValue = 0
        loadingLabel.text = "0%"

        // 6 seconds total / 100 steps = 0.06s per step
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] t in
            guard let self = self else { return }
            if self.currentValue <= 100 {
                self.loadingLabel.text = "\(self.currentValue) %"
                self.currentValue += 1
            } else {
                t.invalidate()
                self.performActionAfterCounting()
            }
        }
    }

    func performActionAfterCounting() {
        UIView.animate(withDuration: 0.3, animations: {
               self.loadingView.alpha = 0
           }, completion: { _ in
               self.loadingView.isHidden = true
               self.loadingView.alpha = 1   // reset so it’s ready if shown again
           })
    }
    
    private func setupLoopingImages() {
        loopingImageContainer.addSubview(scrollingView)
        scrollingView.addSubview(firstImageView)
        scrollingView.addSubview(secondImageView)
        scrollingView.addSubview(thirdImageView)
        
        // Apply rotation to the container
        loopingImageContainer.transform = CGAffineTransform(rotationAngle: -0.2)
    }
    
    private func setupConstraints() {
        let cellHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .phone && UIDevice().isSmallDevice ? 54 : 64
        
        // Setup scrolling view constraint
        scrollingViewLeadingConstraint = scrollingView.leadingAnchor.constraint(equalTo: loopingImageContainer.leadingAnchor)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // BackgroundGradientView
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Looping Image Container - at the top
            loopingImageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -80),
            loopingImageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loopingImageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.5),
            loopingImageContainer.heightAnchor.constraint(equalTo: loopingImageContainer.widthAnchor, multiplier: 0.76),
            
            // Scrolling view constraints
            scrollingViewLeadingConstraint,
            scrollingView.topAnchor.constraint(equalTo: loopingImageContainer.topAnchor),
            scrollingView.bottomAnchor.constraint(equalTo: loopingImageContainer.bottomAnchor),
            scrollingView.widthAnchor.constraint(equalTo: loopingImageContainer.widthAnchor, multiplier: 3),
            
            // First image constraints
            firstImageView.leadingAnchor.constraint(equalTo: scrollingView.leadingAnchor),
            firstImageView.topAnchor.constraint(equalTo: scrollingView.topAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor),
            firstImageView.widthAnchor.constraint(equalTo: loopingImageContainer.widthAnchor),
            
            // Second image constraints (placed right after first image)
            secondImageView.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor),
            secondImageView.topAnchor.constraint(equalTo: scrollingView.topAnchor),
            secondImageView.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor),
            secondImageView.widthAnchor.constraint(equalTo: loopingImageContainer.widthAnchor),
            
            // Third image constraints (placed right after second image)
            thirdImageView.leadingAnchor.constraint(equalTo: secondImageView.trailingAnchor),
            thirdImageView.topAnchor.constraint(equalTo: scrollingView.topAnchor),
            thirdImageView.bottomAnchor.constraint(equalTo: scrollingView.bottomAnchor),
            thirdImageView.widthAnchor.constraint(equalTo: loopingImageContainer.widthAnchor),
            
            // Title Label
            titleStackView.topAnchor.constraint(equalTo: loopingImageContainer.bottomAnchor, constant: -70),
            titleStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleContentView.heightAnchor.constraint(equalToConstant: 28),
            
            titleCenterLabel.leadingAnchor.constraint(equalTo: titleContentView.leadingAnchor, constant: 4),
            titleCenterLabel.trailingAnchor.constraint(equalTo: titleContentView.trailingAnchor, constant: -4),
            titleCenterLabel.topAnchor.constraint(equalTo: titleContentView.topAnchor, constant: 4),
            titleCenterLabel.bottomAnchor.constraint(equalTo: titleContentView.bottomAnchor, constant: -4),
            
            // Features Stack View
            featuresStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20),
            featuresStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Weekly Plan
            weeklyPlanView.topAnchor.constraint(equalTo: featuresStackView.bottomAnchor, constant: 26),
            weeklyPlanView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weeklyPlanView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            weeklyPlanView.heightAnchor.constraint(equalToConstant: cellHeight),
            
            // Monthly Plan
            monthlyPlanView.topAnchor.constraint(equalTo: weeklyPlanView.bottomAnchor, constant: 8),
            monthlyPlanView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            monthlyPlanView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            monthlyPlanView.heightAnchor.constraint(equalToConstant: cellHeight),
            
            // Limited Access Button
            limitedAccessButton.topAnchor.constraint(equalTo: monthlyPlanView.bottomAnchor, constant: 12),
            limitedAccessButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            limitedAccessButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            limitedAccessButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Restore Button
            restoreButton.topAnchor.constraint(equalTo: limitedAccessButton.bottomAnchor, constant: 16),
            restoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Footer Stack View
            footerStackView.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 20),
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Continue Button
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 56),

            // Auto Renew Label
            autoRenewLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 4),
            autoRenewLabel.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor),
            autoRenewLabel.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor),
            autoRenewLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),

            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: -30),
            loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 16),
            loadingView.trailingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Looping Animation Methods
    private func startLoopingAnimation() {
        // Reset position
        scrollingViewLeadingConstraint.constant = 0
        view.layoutIfNeeded()
        
        performLoopingStep()
    }
    
    private func performLoopingStep() {
        UIView.animate(withDuration: 10, delay: 0, options: [.curveLinear], animations: {
            // Move one image width to the left
            self.scrollingViewLeadingConstraint.constant -= self.loopingImageContainer.frame.width
            self.view.layoutIfNeeded()
        }) { _ in
            // Check if we've moved past the second image
            if self.scrollingViewLeadingConstraint.constant <= -self.loopingImageContainer.frame.width * 2 {
                // Reset to show the first image (which looks identical to the third)
                self.scrollingViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
            // Continue the loop
            self.performLoopingStep()
        }
    }
    
    private func setupFeatures() {
        let features = [
            ("checkmark-iap", "Advanced Editing Tools"),
            ("checkmark-iap", "Editing and Mixing"),
            ("checkmark-iap", "No Watermarked Exports"),
            ("checkmark-iap", "Ad-Free Experience")
        ]
        
        features.forEach { iconName, title in
            let featureView = createFeatureView(iconName: iconName, title: title)
            featuresStackView.addArrangedSubview(featureView)
        }
    }
    
    private func createFeatureView(iconName: String, title: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(named: iconName)
        iconImageView.tintColor = .systemGreen
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .label
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return containerView
    }
    
    private func setupIAP() {
        loadingIndicator.startAnimating()
        IAPManager.shared.fetchSubscriptions()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleProductsFetched),
                                               name: NSNotification.Name("ProductsFetched"),
                                               object: nil)
    }
    
    private func localize() {
        // Add your localization strings here
//        titleLabel.text = "Upgrade to Premium" // Strings.Label.upgrade
//        descriptionLabel.text = "Unlock all premium features and enjoy unlimited access" // Strings.Label.iap_description
        termsButton.setTitle("Terms", for: .normal) // Strings.Label.terms
        privacyButton.setTitle("Privacy", for: .normal) // Strings.Label.privacy
        manageButton.setTitle("Manage", for: .normal) // Strings.Label.manage_subs
        restoreButton.setTitle("Restore Purchases", for: .normal) // Strings.Label.restore
    }
    
    // MARK: - Actions
    @objc private func weeklyPlanTapped() {
        selectedPlan = .weekly
        weeklyPlanView.setSelected(true)
        monthlyPlanView.setSelected(false)
    }
    
    @objc private func monthlyPlanTapped() {
        selectedPlan = .monthly
        weeklyPlanView.setSelected(false)
        monthlyPlanView.setSelected(true)
    }
    
    @objc private func continueButtonTapped() {
        guard let selectedProduct = selectedPlan == .monthly ? monthlyProduct : yearlyProduct else {
            showAlert(title: "Error", message: "Unable to load subscription products. Please try again.")
            return
        }
        
        loadingIndicator.startAnimating()
        continueButton.isEnabled = false
        
        IAPManager.shared.subscribe(to: selectedProduct) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.continueButton.isEnabled = true
                
                if success {
                    self?.handleSuccessfulPurchase(message: "Thank you for subscribing!")
                }
            }
        }
    }
    
    @objc private func limitedAccessButtonTapped() {
        delegate?.cancelAction()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func restoreButtonTapped() {
        loadingIndicator.startAnimating()
        
        IAPManager.shared.restoreSubscriptions { [weak self] success, restoredTransactions in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                
                if success {
                    self?.handleSuccessfulPurchase(message: "Purchase was successfully restored")
                } else {
                    self?.showAlert(
                        title: "Restore Failed",
                        message: "No active subscriptions found for this account. Please make sure you're signed in with the correct Apple ID."
                    )
                }
            }
        }
    }
    
    @objc private func termsButtonTapped() {
        LinkOpener.shared.openLink("http://termsofuse.softappstechnology.com", from: self)
    }
    
    @objc private func privacyButtonTapped() {
        LinkOpener.shared.openLink("https://privacy.softappstechnology.com/", from: self)
    }
    
    @objc private func manageButtonTapped() {
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            Task {
                do {
                    try await AppStore.showManageSubscriptions(in: window)
                }
            }
        }
    }
    
    @objc private func handleProductsFetched() {
        let products = IAPManager.shared.getSubscriptions()
        
        monthlyProduct = products.first { $0.productIdentifier == SubscriptionID.monthly.rawValue }
        yearlyProduct = products.first { $0.productIdentifier == SubscriptionID.yearly.rawValue }
        
        if let monthlyProduct = monthlyProduct {
            let price = IAPManager.shared.getFormattedPrice(for: monthlyProduct)
            monthlyPlanView.configure(title: "Monthly Premium", price: price.formatted, period: "month")
        }
        
        if let yearlyProduct = yearlyProduct {
            let price = IAPManager.shared.getFormattedPrice(for: yearlyProduct)
            weeklyPlanView.configure(title: "Yearly Premium", price: price.formatted, period: "year")
        }
        
        loadingIndicator.stopAnimating()
    }
    
    private func handleSuccessfulPurchase(message: String) {
        UserDefaults.standard.set(true, forKey: "isSubscribed")
        delegate?.performAction()
        showAlert(title: "Success", message: message) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loopImage(_ imageView: UIImageView,_ speed:CGFloat) {
        let speeds = speed
        let imageSpeed = speeds / view.frame.size.width
        let averageSpeed = (view.frame.size.width - imageView.frame.origin.x) * imageSpeed
        UIView.animate(withDuration: TimeInterval(averageSpeed), delay: 0.0, options: .curveLinear, animations: {
            imageView.frame.origin.x = self.view.frame.size.width
        }, completion: { (_) in
            imageView.frame.origin.x = -imageView.frame.size.width
            self.loopImage(imageView,speeds)
        })
    }
}

// MARK: - Alternative implementation with CABasicAnimation for smoother performance
extension IAPOnboardingViewController {
    
    private func startLoopingAnimationWithCAAnimation() {
        // Stop any existing animations
        scrollingView.layer.removeAllAnimations()
        
        // Reset position
        scrollingView.transform = .identity
        
        // Create seamless looping animation
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = 0
        animation.toValue = -loopingImageContainer.frame.width * 2
        animation.duration = 3.0
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        // This is key for smooth looping - it will seamlessly restart
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        scrollingView.layer.add(animation, forKey: "looping")
        
        // Alternative approach using keyframe animation for even smoother results
        startKeyframeLoopingAnimation()
    }
    
    private func startKeyframeLoopingAnimation() {
        scrollingView.layer.removeAllAnimations()
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        // Define positions: start, after 1st image, after 2nd image, back to start
        animation.values = [0, -loopingImageContainer.frame.width, -loopingImageContainer.frame.width * 2, 0]
        animation.keyTimes = [0, 0.33, 0.66, 1.0]
        animation.duration = 3.0
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.calculationMode = .linear
        
        scrollingView.layer.add(animation, forKey: "smoothLooping")
    }
}

// MARK: - Usage example with custom configuration
extension IAPOnboardingViewController {
    
    func configureLooping(duration: TimeInterval = 3.0, direction: ScrollDirection = .leftToRight) {
        // You can call this method to customize the looping behavior
        // Implementation would depend on your specific needs
    }
    
    enum ScrollDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
}
