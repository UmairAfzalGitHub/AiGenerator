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
    private lazy var topImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var selectedParent1Image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGreen
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 12
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.borderWidth = 1
        image.isUserInteractionEnabled = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var selectedParent2Image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemTeal
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 12
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.borderWidth = 1
        image.isUserInteractionEnabled = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var heartImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "heart.fill")
        image.backgroundColor = .clear
        image.tintColor = .systemRed
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var generatedBabyImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 12
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.borderWidth = 1
        image.isUserInteractionEnabled = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var handImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.image = UIImage(systemName: "hand.rays")
        image.backgroundColor = .clear
        image.alpha  = 0.5
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
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
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
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
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleEndLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Access"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
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
        button.backgroundColor = .clear
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
        setupConstraints()
        setupFeatures()
        setupIAP()
        localize()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topImageContainer)
        contentView.addSubview(backgroundImageView)
        
        // Add images directly inside topImageContainer
        topImageContainer.addSubview(selectedParent1Image)
        topImageContainer.addSubview(selectedParent2Image)
        topImageContainer.addSubview(generatedBabyImage)
        topImageContainer.addSubview(heartImage)
        generatedBabyImage.addSubview(handImage)
        
        // Add other UI elements
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] t in
            guard let self = self else { return }
            if self.currentValue <= 100 {
                self.loadingLabel.text = "\(self.currentValue) %"
                self.currentValue += 1
            } else {
                t.invalidate()
                self.animateImagesIn()
                self.performActionAfterCounting()
            }
        }
    }

    func animateImagesIn() {
        // initial positions
        selectedParent1Image.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0) // left offscreen
        selectedParent2Image.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)  // right offscreen
        generatedBabyImage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0) // scaled to 0
        heartImage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0) // scaled to 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.6,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations: {
                self.selectedParent1Image.transform = .identity
                self.selectedParent2Image.transform = .identity
            })
            
            UIView.animate(withDuration: 0.6,
                           delay: 0.5,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations: {
                self.generatedBabyImage.transform = .identity
                self.heartImage.transform = .identity
            })
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
    
    private func setupConstraints() {
        let cellHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .phone && UIDevice().isSmallDevice ? 54 : 64
        
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
            
            // Looping Image Container
            topImageContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            topImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topImageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Parent Image 1
            selectedParent1Image.topAnchor.constraint(equalTo: topImageContainer.topAnchor, constant: 20),
            selectedParent1Image.leadingAnchor.constraint(equalTo: topImageContainer.leadingAnchor, constant: 30),
            selectedParent1Image.widthAnchor.constraint(equalTo: topImageContainer.widthAnchor, multiplier: 0.5, constant: -40),
            selectedParent1Image.heightAnchor.constraint(equalTo: selectedParent1Image.widthAnchor),
            
            // Parent Image 2
            selectedParent2Image.topAnchor.constraint(equalTo: topImageContainer.topAnchor, constant: 20),
            selectedParent2Image.trailingAnchor.constraint(equalTo: topImageContainer.trailingAnchor, constant: -30),
            selectedParent2Image.widthAnchor.constraint(equalTo: topImageContainer.widthAnchor, multiplier: 0.5, constant: -40),
            selectedParent2Image.heightAnchor.constraint(equalTo: selectedParent2Image.widthAnchor),
            
            heartImage.centerXAnchor.constraint(equalTo: topImageContainer.centerXAnchor),
            heartImage.centerYAnchor.constraint(equalTo: selectedParent2Image.centerYAnchor),
            heartImage.widthAnchor.constraint(equalTo: topImageContainer.widthAnchor, multiplier: 0.17),
            heartImage.heightAnchor.constraint(equalTo: heartImage.widthAnchor),
            
            // Baby Image
            generatedBabyImage.topAnchor.constraint(equalTo: selectedParent1Image.bottomAnchor, constant: 16),
            generatedBabyImage.centerXAnchor.constraint(equalTo: topImageContainer.centerXAnchor),
            generatedBabyImage.widthAnchor.constraint(equalTo: topImageContainer.widthAnchor, multiplier: 0.5),
            generatedBabyImage.heightAnchor.constraint(equalTo: generatedBabyImage.widthAnchor),
            generatedBabyImage.bottomAnchor.constraint(equalTo: topImageContainer.bottomAnchor, constant: -20),
            
            handImage.centerXAnchor.constraint(equalTo: generatedBabyImage.centerXAnchor),
            handImage.centerYAnchor.constraint(equalTo: generatedBabyImage.centerYAnchor),
            handImage.widthAnchor.constraint(equalToConstant: 42),
            handImage.heightAnchor.constraint(equalTo: handImage.widthAnchor),
            
            // Title Label
            titleStackView.topAnchor.constraint(equalTo: topImageContainer.bottomAnchor, constant: 16),
            titleStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleContentView.heightAnchor.constraint(equalToConstant: 28),
            
            titleCenterLabel.leadingAnchor.constraint(equalTo: titleContentView.leadingAnchor, constant: 4),
            titleCenterLabel.trailingAnchor.constraint(equalTo: titleContentView.trailingAnchor, constant: -4),
            titleCenterLabel.topAnchor.constraint(equalTo: titleContentView.topAnchor, constant: 4),
            titleCenterLabel.bottomAnchor.constraint(equalTo: titleContentView.bottomAnchor, constant: -4),
            
            // Features Stack View
            featuresStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 16),
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
    
    private func setupFeatures() {
        let features = [
            ("checkmark.shield.fill", "Advanced Editing Tools"),
            ("checkmark.shield.fill", "Editing and Mixing"),
            ("checkmark.shield.fill", "No Watermarked Exports"),
            ("checkmark.shield.fill", "Ad-Free Experience")
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
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .white
        
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
