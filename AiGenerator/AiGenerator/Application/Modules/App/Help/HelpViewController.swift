//
//  HelpViewController.swift
//  AiGenerator
//
//  Created by Haider on 12/09/2025.
//

import UIKit

class HelpViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        setupScrollView()
        setupContent()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupContent() {
        // Title
        let titleLabel = createTitleLabel()
        
        // Tips container
        let tipsContainer = createTipsContainer()
        
        // Good examples section
        let goodExamplesSection = createGoodExamplesSection()
        
        // Bad examples section
        let badExamplesSection = createBadExamplesSection()
        
        // Understand button
        let understandButton = createUnderstandButton()
        
        // Add all views to content
        [titleLabel, tipsContainer, goodExamplesSection, badExamplesSection, understandButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            tipsContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tipsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            tipsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            goodExamplesSection.topAnchor.constraint(equalTo: tipsContainer.bottomAnchor, constant: 40),
            goodExamplesSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            goodExamplesSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            badExamplesSection.topAnchor.constraint(equalTo: goodExamplesSection.bottomAnchor, constant: 30),
            badExamplesSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            badExamplesSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            understandButton.topAnchor.constraint(equalTo: badExamplesSection.bottomAnchor, constant: 40),
            understandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            understandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            understandButton.heightAnchor.constraint(equalToConstant: 56),
            understandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "For Best Results"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }
    
    private func createTipsContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        container.layer.cornerRadius = 16
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tips = [
            "Look directly at the camera.",
            "Keep your photo centered and straight.",
            "Avoid wearing glasses.",
            "Make sure your face and eyes are clearly visible."
        ]
        
        tips.forEach { tipText in
            let tipView = createTipView(text: tipText)
            stackView.addArrangedSubview(tipView)
        }
        
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])
        
        return container
    }
    
    private func createTipView(text: String) -> UIView {
        let containerView = UIView()
        
        let bulletView = UIView()
        bulletView.backgroundColor = .white
        bulletView.layer.cornerRadius = 3
        bulletView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(bulletView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            bulletView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bulletView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            bulletView.widthAnchor.constraint(equalToConstant: 6),
            bulletView.heightAnchor.constraint(equalToConstant: 6),
            
            label.leadingAnchor.constraint(equalTo: bulletView.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func createGoodExamplesSection() -> UIView {
        let container = UIView()
        
        // Header with checkmark
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmark.tintColor = .systemGreen
        checkmark.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = "Good Examples"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        headerStack.addArrangedSubview(checkmark)
        headerStack.addArrangedSubview(titleLabel)
        
        // Images container
        let imagesStack = UIStackView()
        imagesStack.axis = .horizontal
        imagesStack.spacing = 12
        imagesStack.distribution = .fillEqually
        imagesStack.translatesAutoresizingMaskIntoConstraints = false
        
        let goodImage1 = createExampleImageView(backgroundColor: UIColor(red: 1.0, green: 0.7, blue: 0.8, alpha: 1.0), hasCheckmark: true)
        let goodImage2 = createExampleImageView(backgroundColor: UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0), hasCheckmark: true)
        
        imagesStack.addArrangedSubview(goodImage1)
        imagesStack.addArrangedSubview(goodImage2)
        
        container.addSubview(headerStack)
        container.addSubview(imagesStack)
        
        NSLayoutConstraint.activate([
            checkmark.widthAnchor.constraint(equalToConstant: 24),
            checkmark.heightAnchor.constraint(equalToConstant: 24),
            
            headerStack.topAnchor.constraint(equalTo: container.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            imagesStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 16),
            imagesStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imagesStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imagesStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imagesStack.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        return container
    }
    
    private func createBadExamplesSection() -> UIView {
        let container = UIView()
        
        // Header with X mark
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let xmark = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
        xmark.tintColor = .systemRed
        xmark.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = "Bad Examples"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        headerStack.addArrangedSubview(xmark)
        headerStack.addArrangedSubview(titleLabel)
        
        // First row of images
        let firstRowStack = UIStackView()
        firstRowStack.axis = .horizontal
        firstRowStack.spacing = 12
        firstRowStack.distribution = .fillEqually
        firstRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        let badImage1 = createBadExampleImageView(backgroundColor: UIColor(red: 0.3, green: 0.25, blue: 0.2, alpha: 1.0), errorText: "No Face")
        let badImage2 = createBadExampleImageView(backgroundColor: UIColor(red: 0.25, green: 0.2, blue: 0.15, alpha: 1.0), errorText: "Low Light")
        
        firstRowStack.addArrangedSubview(badImage1)
        firstRowStack.addArrangedSubview(badImage2)
        
        // Second row of images
        let secondRowStack = UIStackView()
        secondRowStack.axis = .horizontal
        secondRowStack.spacing = 12
        secondRowStack.distribution = .fillEqually
        secondRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        let badImage3 = createBadExampleImageView(backgroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), errorText: "Closed Eyes")
        let badImage4 = createBadExampleImageView(backgroundColor: UIColor(red: 0.7, green: 0.6, blue: 0.5, alpha: 1.0), errorText: "Multiple Faces")
        
        secondRowStack.addArrangedSubview(badImage3)
        secondRowStack.addArrangedSubview(badImage4)
        
        container.addSubview(headerStack)
        container.addSubview(firstRowStack)
        container.addSubview(secondRowStack)
        
        NSLayoutConstraint.activate([
            xmark.widthAnchor.constraint(equalToConstant: 24),
            xmark.heightAnchor.constraint(equalToConstant: 24),
            
            headerStack.topAnchor.constraint(equalTo: container.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            firstRowStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 16),
            firstRowStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            firstRowStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            firstRowStack.heightAnchor.constraint(equalToConstant: 160),
            
            secondRowStack.topAnchor.constraint(equalTo: firstRowStack.bottomAnchor, constant: 12),
            secondRowStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            secondRowStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            secondRowStack.heightAnchor.constraint(equalToConstant: 160),
            secondRowStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createExampleImageView(backgroundColor: UIColor, hasCheckmark: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = backgroundColor
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        
        if hasCheckmark {
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            checkmark.tintColor = .systemGreen
            checkmark.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            checkmark.layer.cornerRadius = 12
            checkmark.contentMode = .scaleAspectFit
            checkmark.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(checkmark)
            
            NSLayoutConstraint.activate([
                checkmark.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
                checkmark.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
                checkmark.widthAnchor.constraint(equalToConstant: 24),
                checkmark.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
        
        return container
    }
    
    private func createBadExampleImageView(backgroundColor: UIColor, errorText: String) -> UIView {
        let container = UIView()
        container.backgroundColor = backgroundColor
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        
        // Error label at bottom
        let errorLabel = UILabel()
        errorLabel.text = errorText
        errorLabel.textColor = .white
        errorLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        errorLabel.textAlignment = .center
        errorLabel.clipsToBounds = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Error icon
        let errorIcon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        errorIcon.tintColor = .systemRed
        errorIcon.contentMode = .scaleAspectFit
        errorIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let errorStack = UIStackView(arrangedSubviews: [errorIcon, errorLabel])
        errorStack.axis = .horizontal
        errorStack.spacing = 6
        errorStack.alignment = .center
        errorStack.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        errorStack.layer.cornerRadius = 12
        errorStack.isLayoutMarginsRelativeArrangement = true
        errorStack.layoutMargins = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        errorStack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(errorStack)
        
        NSLayoutConstraint.activate([
            errorIcon.widthAnchor.constraint(equalToConstant: 16),
            errorIcon.heightAnchor.constraint(equalToConstant: 16),
            
            errorStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            errorStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            errorStack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -8)
        ])
        
        return container
    }
    
    private func createUnderstandButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("I Understand", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        // Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.appPrimaryBlue.cgColor,
            UIColor.appPrimary.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 28
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(understandButtonTapped), for: .touchUpInside)
        
        // Update gradient frame when layout changes
        button.layoutSubviews()
        DispatchQueue.main.async {
            gradientLayer.frame = button.bounds
        }
        
        return button
    }
    
    @objc private func understandButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update gradient layer frame
        if let button = contentView.subviews.last as? UIButton,
           let gradientLayer = button.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = button.bounds
        }
    }
}
