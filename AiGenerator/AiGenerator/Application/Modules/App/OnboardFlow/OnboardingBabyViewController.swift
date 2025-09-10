//
//  OnboardingBabyViewController.swift
//  AiGenerator
//
//  Created by Haider on 06/08/2025.
//

import UIKit

class OnboardingBabyViewController: BaseViewController,
                                    UIImagePickerControllerDelegate &
                                    UINavigationControllerDelegate {
    
    enum ProgressStep {
        case first
        case second
        case result
    }
    
    private var currentStep: ProgressStep = .first
    private var selectedSkinTypeIndex: Int? = nil
    
    convenience init(step: ProgressStep = .first) {
        self.init()
        self.currentStep = step
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    // MARK: - UI Properties
    private var uploadArea: UIView!
    private var uploadIcon: UIImageView!
    private var plusButton: UIButton!
    private var resetParentImageButton: UIButton!
    private var continueButton: UIButton!
    private var parentImageView: UIImageView!
    private var progressDot1: UIView!
    private var progressDot2: UIView!
    private var parentLabel: UILabel!
    private var exampleImage1: UIImageView!
    private var exampleImage2: UIImageView!
    // Skin Type UI
    private var skinTypeLabel: UILabel!
    private var skinTypeStack: UIStackView!
    private var skinTypeButtons: [UIButton] = []
    // Example/Or UI
    private var orLabel: UILabel!
    private var chooseLabel: UILabel!
    private var exampleStack: UIStackView!
    
    private func setupUI() {
        // Update label for step
        if currentStep == .second {
            parentLabel?.text = "Parent 2"
        }
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Meet Your Future Baby"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Subtitle Label
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Upload photos of both parents, and our AI\nwill predict your baby's face."
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = UIColor(white: 0.85, alpha: 1)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        // Progress Indicator (2 dots in stack)
        let progressStack = UIStackView()
        progressStack.axis = .horizontal
        progressStack.alignment = .center
        progressStack.distribution = .equalSpacing
        progressStack.spacing = 12
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressStack)
        
        progressDot1 = UIView()
        progressDot1.layer.cornerRadius = 3
        progressDot1.translatesAutoresizingMaskIntoConstraints = false
        progressStack.addArrangedSubview(progressDot1)
        progressDot1.widthAnchor.constraint(equalToConstant: 52).isActive = true
        progressDot1.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        progressDot2 = UIView()
        progressDot2.layer.cornerRadius = 3
        progressDot2.translatesAutoresizingMaskIntoConstraints = false
        progressStack.addArrangedSubview(progressDot2)
        progressDot2.widthAnchor.constraint(equalToConstant: 54).isActive = true
        progressDot2.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        updateProgressDots(for: currentStep)
        
        // Parent Photo Upload Area
        uploadArea = UIView()
        uploadArea.backgroundColor = UIColor(white: 0.12, alpha: 1)
        uploadArea.layer.cornerRadius = 20
        uploadArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uploadArea)
        
        // Upload Icon
        uploadIcon = UIImageView(image: UIImage(systemName: "person.crop.square"))
        uploadIcon.tintColor = UIColor(white: 0.5, alpha: 1)
        uploadIcon.contentMode = .scaleAspectFit
        uploadIcon.translatesAutoresizingMaskIntoConstraints = false
        uploadArea.addSubview(uploadIcon)
        
        // Parent 1 Label
        parentLabel = UILabel()
        parentLabel.text = (currentStep == .second) ? "Parent 2" : "Parent 1"
        parentLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        parentLabel.textColor = .white
        parentLabel.textAlignment = .center
        parentLabel.translatesAutoresizingMaskIntoConstraints = false
        uploadArea.addSubview(parentLabel)
        
        // Plus Button
        plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.tintColor = .white
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        uploadArea.addSubview(plusButton)
        
        parentImageView = UIImageView(image: nil)
        parentImageView?.contentMode = .scaleAspectFill
        parentImageView?.clipsToBounds = true
        parentImageView?.layer.cornerRadius = 16
        parentImageView?.translatesAutoresizingMaskIntoConstraints = false
        uploadArea.addSubview(parentImageView)
        
        resetParentImageButton = UIButton(type: .system)
        resetParentImageButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        resetParentImageButton.tintColor = .white
        resetParentImageButton.addTarget(self, action: #selector(resetImageTapped), for: .touchUpInside)
        resetParentImageButton.translatesAutoresizingMaskIntoConstraints = false
        uploadArea.addSubview(resetParentImageButton)
        
        resetParentImageButton.isHidden = true
        
        // "or" Label
        orLabel = UILabel()
        orLabel.text = "or"
        orLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        orLabel.textColor = UIColor(white: 0.7, alpha: 1)
        orLabel.textAlignment = .center
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(orLabel)
        
        // Choose from example photos label
        chooseLabel = UILabel()
        chooseLabel.text = "Choose from example photos"
        chooseLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        chooseLabel.textColor = UIColor(white: 0.7, alpha: 1)
        chooseLabel.textAlignment = .center
        chooseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chooseLabel)
        
        // Example Parent Photos
        exampleStack = UIStackView()
        exampleStack.axis = .horizontal
        exampleStack.alignment = .center
        exampleStack.distribution = .equalSpacing
        exampleStack.spacing = 24
        exampleStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exampleStack)
        
        exampleImage1 = UIImageView(image: UIImage(systemName: "person.circle"))
        exampleImage1.tintColor = .white
        exampleImage1.backgroundColor = UIColor(white: 0.2, alpha: 1)
        exampleImage1.layer.cornerRadius = 36
        exampleImage1.clipsToBounds = true
        exampleImage1.contentMode = .scaleAspectFill
        exampleImage1.translatesAutoresizingMaskIntoConstraints = false
        exampleImage1.isUserInteractionEnabled = true
        exampleImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exampleImage1Tapped)))
        exampleStack.addArrangedSubview(exampleImage1)
        
        exampleImage2 = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        exampleImage2.tintColor = .white
        exampleImage2.backgroundColor = UIColor(white: 0.2, alpha: 1)
        exampleImage2.layer.cornerRadius = 36
        exampleImage2.clipsToBounds = true
        exampleImage2.contentMode = .scaleAspectFill
        exampleImage2.isUserInteractionEnabled = true
        exampleImage2.translatesAutoresizingMaskIntoConstraints = false
        exampleImage2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exampleImage2Tapped)))
        exampleStack.addArrangedSubview(exampleImage2)
        
        // Skin Type Label (hidden by default)
        skinTypeLabel = UILabel()
        skinTypeLabel.text = "Skin Type"
        skinTypeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        skinTypeLabel.textColor = .white
        skinTypeLabel.textAlignment = .center
        skinTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        skinTypeLabel.isHidden = true
        view.addSubview(skinTypeLabel)
        
        // Skin Type Stack (hidden by default)
        skinTypeStack = UIStackView()
        skinTypeStack.axis = .horizontal
        skinTypeStack.alignment = .center
        skinTypeStack.distribution = .equalSpacing
        skinTypeStack.spacing = 16
        skinTypeStack.translatesAutoresizingMaskIntoConstraints = false
        skinTypeStack.isHidden = true
        view.addSubview(skinTypeStack)
        
        let skinTypeImages = ["hand.raised.fill", "hand.raised.fill", "hand.raised.fill", "hand.raised.fill"]
        let skinColors: [UIColor] = [
            UIColor(red: 1.0, green: 0.88, blue: 0.78, alpha: 1.0), // light
            UIColor(red: 0.85, green: 0.65, blue: 0.45, alpha: 1.0), // tan
            UIColor(red: 0.60, green: 0.40, blue: 0.25, alpha: 1.0), // brown
            UIColor(red: 0.30, green: 0.20, blue: 0.13, alpha: 1.0)  // dark
        ]
        for (i, imageName) in skinTypeImages.enumerated() {
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
            let image = UIImage(systemName: imageName, withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            button.tintColor = skinColors[i]
            button.backgroundColor = UIColor(white: 0.12, alpha: 1)
            button.layer.cornerRadius = 22
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.clear.cgColor
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i // Set tag to identify the button
            button.addTarget(self, action: #selector(skinTypeButtonTapped(_:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 44).isActive = true
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            skinTypeStack.addArrangedSubview(button)
            skinTypeButtons.append(button)
        }
        
        // Continue Button
        continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.backgroundColor = UIColor(white: 0.5, alpha: 1)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        continueButton.layer.cornerRadius = 24
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            progressStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            progressStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            uploadArea.topAnchor.constraint(equalTo: progressStack.bottomAnchor, constant: 48),
            uploadArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadArea.widthAnchor.constraint(equalToConstant: 280),
            uploadArea.heightAnchor.constraint(equalToConstant: 250),
            
            uploadIcon.topAnchor.constraint(equalTo: uploadArea.topAnchor, constant: 42),
            uploadIcon.centerXAnchor.constraint(equalTo: uploadArea.centerXAnchor),
            uploadIcon.widthAnchor.constraint(equalToConstant: 44),
            uploadIcon.heightAnchor.constraint(equalToConstant: 44),
            
            parentLabel.topAnchor.constraint(equalTo: uploadIcon.bottomAnchor, constant: 12),
            parentLabel.centerXAnchor.constraint(equalTo: uploadArea.centerXAnchor),
            
            plusButton.topAnchor.constraint(equalTo: parentLabel.bottomAnchor, constant: 26),
            plusButton.centerXAnchor.constraint(equalTo: uploadArea.centerXAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 56),
            plusButton.heightAnchor.constraint(equalToConstant: 56),
            
            parentImageView.widthAnchor.constraint(equalTo: uploadArea.widthAnchor),
            parentImageView.heightAnchor.constraint(equalTo: uploadArea.heightAnchor),
            parentImageView.centerXAnchor.constraint(equalTo: uploadArea.centerXAnchor),
            
            resetParentImageButton.trailingAnchor.constraint(equalTo: uploadArea.trailingAnchor, constant: -10),
            resetParentImageButton.bottomAnchor.constraint(equalTo: uploadArea.bottomAnchor, constant: -10),
            
            orLabel.topAnchor.constraint(equalTo: uploadArea.bottomAnchor, constant: 32),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chooseLabel.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 4),
            chooseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            exampleStack.topAnchor.constraint(equalTo: chooseLabel.bottomAnchor, constant: 16),
            exampleStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exampleImage1.widthAnchor.constraint(equalToConstant: 72),
            exampleImage1.heightAnchor.constraint(equalToConstant: 72),
            exampleImage2.widthAnchor.constraint(equalToConstant: 72),
            exampleImage2.heightAnchor.constraint(equalToConstant: 72),
            
            // Skin Type Label and Stack
            skinTypeLabel.topAnchor.constraint(equalTo: uploadArea.bottomAnchor, constant: 24),
            skinTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skinTypeStack.topAnchor.constraint(equalTo: skinTypeLabel.bottomAnchor, constant: 12),
            skinTypeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skinTypeStack.heightAnchor.constraint(equalToConstant: 44),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - IBActions
    @objc private func exampleImage1Tapped() {
        showSelecetedImage(exampleImage1.image ?? UIImage())
    }
    
    @objc private func exampleImage2Tapped() {
        showSelecetedImage(exampleImage2.image ?? UIImage())
    }
    
    @objc private func plusButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc private func skinTypeButtonTapped(_ sender: UIButton) {
        // Update selected skin type index
        selectedSkinTypeIndex = sender.tag
        
        // Update button appearances
        updateSkinTypeSelection()
    }
    
    @objc private func continueButtonTapped() {
        // Push a new instance with .second step
        guard parentImageView.image != nil else { return }
        var nextVC = UIViewController()
        if currentStep == .first {
            nextVC = OnboardingBabyViewController(step: .second)
        } else if currentStep == .second {
            let iapVC = IAPOnboardingViewController()
            iapVC.delegate = self
            iapVC.modalPresentationStyle = .fullScreen
            iapVC.modalTransitionStyle = .coverVertical
            self.present(iapVC, animated: true)
            return
        }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func updateProgressDots(for step: ProgressStep) {
        switch step {
        case .first:
            progressDot1.backgroundColor = .white
            progressDot2.backgroundColor = UIColor(white: 0.2, alpha: 1)
        case .second:
            progressDot1.backgroundColor = UIColor(white: 0.2, alpha: 1)
            progressDot2.backgroundColor = .white
        case .result: break
        }
    }
    
    private func updateSkinTypeSelection() {
        for (index, button) in skinTypeButtons.enumerated() {
            if index == selectedSkinTypeIndex {
                // Selected state - show white border
                button.layer.borderColor = UIColor.white.cgColor
            } else {
                // Unselected state - clear border
                button.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    @objc private func resetImageTapped() {
        uploadIcon.isHidden = false
        plusButton.isHidden = false
        parentLabel.isHidden = false
        resetParentImageButton.isHidden = true
        parentImageView.image = nil
        // Reset skin type selection
        selectedSkinTypeIndex = nil
        updateSkinTypeSelection()
        setSkinTypeAndExampleVisibility(imageSet: false)
        continueButton.isUserInteractionEnabled = false
        continueButton.backgroundColor = UIColor(white: 0.5, alpha: 1)
    }
    
    private func showSelecetedImage(_ image: UIImage) {
        uploadIcon.isHidden = true
        plusButton.isHidden = true
        parentLabel.isHidden = true
        resetParentImageButton.isHidden = false
        parentImageView.image = image
        // Hide or/choose/example, show skin type
        setSkinTypeAndExampleVisibility(imageSet: true)
        continueButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }
    
    // Helper to toggle skin type/example/or/choose UI
    private func setSkinTypeAndExampleVisibility(imageSet: Bool) {
        orLabel?.isHidden = imageSet
        chooseLabel?.isHidden = imageSet
        exampleStack?.isHidden = imageSet
        skinTypeLabel?.isHidden = !imageSet
        skinTypeStack?.isHidden = !imageSet
    }
    
    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            showSelecetedImage(image)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    //MARK: - IAPOnboardingViewControllerDelegate
    override func performAction() {
        print("hello")
    }
    
    override func cancelAction() {
        let controller = UINavigationController(rootViewController: HomeViewContoller()) 
        UIApplication.shared.updateRootViewController(to: controller)
    }
}
