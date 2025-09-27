//
//  ResultViewController.swift
//  AiGenerator
//
//  Created by Umair Afzal on 23/09/2025.
//

import UIKit

class ResultViewController: BaseViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Result Image Section
    private let resultImageContainer = UIView()
    private let resultImageView = UIImageView()
    
    // Action Buttons
    private let actionButtonsStack = UIStackView()
    private let shareButton = ActionButton()
    private let saveButton = ActionButton()
    private let regenerateButton = ActionButton()
    
    // Bottom Button
    private let createNewButton = GradientActionButton(type: .system)
    
    // MARK: - Properties
    private var babyImage: UIImage!
    private var babyName: String = ""
    
    // MARK: - Initialization
    convenience init(image: UIImage, name: String) {
        self.init()
        self.babyImage = image
        self.babyName = name
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = babyName  // Use baby name as title
        setupCustomNavigationBar()
        setupScrollHierarchy()
        setupResultImageSection()
        setupActionButtons()
        setupCreateNewButton()
    }
    
    // Custom navigation bar without the standard buttons
    private func setupCustomNavigationBar() {
        // Hide default navigation bar buttons
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItems = nil
        
        // Add only a back button
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update gradient borders when layout changes
        resultImageContainer.updateGradientBorder()
    }
    
    // MARK: - Setup
    private func setupScrollHierarchy() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Note: bottomAnchor will be set in setupCreateNewButton() to be above the button
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupResultImageSection() {
        // Configure container
        resultImageContainer.backgroundColor = UIColor(white: 0.12, alpha: 1)
        resultImageContainer.layer.cornerRadius = 16
        resultImageContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(resultImageContainer)
        
        // Configure image view
        resultImageView.contentMode = .scaleAspectFit
        resultImageView.clipsToBounds = true
        resultImageView.layer.cornerRadius = 12
        resultImageView.backgroundColor = .clear
        resultImageView.image = babyImage // Using the stored property
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        resultImageContainer.addSubview(resultImageView)
        
        // Apply gradient border to container
        let gradientColors = [
            UIColor.appPrimary.cgColor,
            UIColor.appPrimaryBlue.cgColor
        ]
        resultImageContainer.addGradientBorder(
            colors: gradientColors,
            width: 2.0,
            cornerRadius: 16
        )
        
        NSLayoutConstraint.activate([
            resultImageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            resultImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultImageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            resultImageContainer.heightAnchor.constraint(equalTo: resultImageContainer.widthAnchor),
            
            resultImageView.topAnchor.constraint(equalTo: resultImageContainer.topAnchor, constant: 12),
            resultImageView.leadingAnchor.constraint(equalTo: resultImageContainer.leadingAnchor, constant: 12),
            resultImageView.trailingAnchor.constraint(equalTo: resultImageContainer.trailingAnchor, constant: -12),
            resultImageView.bottomAnchor.constraint(equalTo: resultImageContainer.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupActionButtons() {
        actionButtonsStack.axis = .horizontal
        actionButtonsStack.distribution = .fillEqually
        actionButtonsStack.spacing = 16
        actionButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actionButtonsStack)
        
        // Configure share button
        shareButton.configure(text: "Share", systemIcon: "square.and.arrow.up")
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        
        // Configure save button
        saveButton.configure(text: "Save", systemIcon: "square.and.arrow.down")
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        // Configure regenerate button
        regenerateButton.configure(text: "Regenerate", systemIcon: "arrow.clockwise")
        regenerateButton.addTarget(self, action: #selector(regenerateTapped), for: .touchUpInside)
        
        actionButtonsStack.addArrangedSubview(shareButton)
        actionButtonsStack.addArrangedSubview(saveButton)
        actionButtonsStack.addArrangedSubview(regenerateButton)
        
        NSLayoutConstraint.activate([
            actionButtonsStack.topAnchor.constraint(equalTo: resultImageContainer.bottomAnchor, constant: 32),
            actionButtonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actionButtonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionButtonsStack.heightAnchor.constraint(equalToConstant: 56),
            actionButtonsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupCreateNewButton() {
        createNewButton.setTitle("Create New Baby", for: .normal)
        createNewButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        createNewButton.setTitleColor(.white, for: .normal)
        createNewButton.translatesAutoresizingMaskIntoConstraints = false
        createNewButton.addTarget(self, action: #selector(createNewTapped), for: .touchUpInside)
        
        // Add the button directly to the main view (not contentView)
        view.addSubview(createNewButton)
        
        NSLayoutConstraint.activate([
            // Position the button at the bottom of the screen
            createNewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createNewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createNewButton.heightAnchor.constraint(equalToConstant: 56),
            createNewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Constrain scrollView to end above the create new button
            scrollView.bottomAnchor.constraint(equalTo: createNewButton.topAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    @objc private func shareTapped() {
        let activityVC = UIActivityViewController(activityItems: [babyImage, "Check out my AI-generated baby: \(babyName)"], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func saveTapped() {
        UIImageWriteToSavedPhotosAlbum(babyImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func regenerateTapped() {
        // Pop back to home screen to regenerate
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createNewTapped() {
        // Pop to root or specific view controller to start over
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Save Error", message: error.localizedDescription)
        } else {
            showAlert(title: "Saved", message: "Baby image has been saved to your photos.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Action Button
class ActionButton: UIControl {
    private let container = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func configure(text: String, systemIcon: String) {
        titleLabel.text = text
        iconView.image = UIImage(systemName: systemIcon)
    }
    
    private func setup() {
        container.backgroundColor = UIColor(white: 0.12, alpha: 1)
        container.layer.cornerRadius = 16
        container.isUserInteractionEnabled = false
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        iconView.tintColor = UIColor(white: 0.8, alpha: 1)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(iconView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
    }
}
