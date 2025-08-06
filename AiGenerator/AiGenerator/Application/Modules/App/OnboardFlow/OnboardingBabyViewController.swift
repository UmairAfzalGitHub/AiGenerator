//
//  OnboardingBabyViewController.swift
//  AiGenerator
//
//  Created by Haider on 06/08/2025.
//

import UIKit

class OnboardingBabyViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    enum ProgressStep {
        case first
        case second
    }
    private var currentStep: ProgressStep = .first
    
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
    private var parentImageView: UIImageView!
    private var progressDot1: UIView!
    private var progressDot2: UIView!
    private var parentLabel: UILabel!

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
        parentLabel.text = "Parent 1"
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

        parentImageView = UIImageView()
        parentImageView?.contentMode = .scaleAspectFill
        parentImageView?.clipsToBounds = true
        parentImageView?.layer.cornerRadius = 16
        parentImageView?.translatesAutoresizingMaskIntoConstraints = false
        uploadArea.addSubview(parentImageView)
        
        // "or" Label
        let orLabel = UILabel()
        orLabel.text = "or"
        orLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        orLabel.textColor = UIColor(white: 0.7, alpha: 1)
        orLabel.textAlignment = .center
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(orLabel)

        // Choose from example photos label
        let chooseLabel = UILabel()
        chooseLabel.text = "Choose from example photos"
        chooseLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        chooseLabel.textColor = UIColor(white: 0.7, alpha: 1)
        chooseLabel.textAlignment = .center
        chooseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chooseLabel)

        // Example Parent Photos
        let exampleStack = UIStackView()
        exampleStack.axis = .horizontal
        exampleStack.alignment = .center
        exampleStack.distribution = .equalSpacing
        exampleStack.spacing = 24
        exampleStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exampleStack)

        let example1 = UIImageView(image: UIImage(systemName: "person.circle"))
        example1.tintColor = .white
        example1.backgroundColor = UIColor(white: 0.2, alpha: 1)
        example1.layer.cornerRadius = 36
        example1.clipsToBounds = true
        example1.contentMode = .scaleAspectFill
        example1.translatesAutoresizingMaskIntoConstraints = false
        exampleStack.addArrangedSubview(example1)
        let example2 = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        example2.tintColor = .white
        example2.backgroundColor = UIColor(white: 0.2, alpha: 1)
        example2.layer.cornerRadius = 36
        example2.clipsToBounds = true
        example2.contentMode = .scaleAspectFill
        example2.translatesAutoresizingMaskIntoConstraints = false
        exampleStack.addArrangedSubview(example2)

        // Continue Button
        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
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
            uploadArea.heightAnchor.constraint(equalToConstant: 220),

            uploadIcon.topAnchor.constraint(equalTo: uploadArea.topAnchor, constant: 32),
            uploadIcon.centerXAnchor.constraint(equalTo: uploadArea.centerXAnchor),
            uploadIcon.widthAnchor.constraint(equalToConstant: 44),
            uploadIcon.heightAnchor.constraint(equalToConstant: 44),

            parentLabel.topAnchor.constraint(equalTo: uploadIcon.bottomAnchor, constant: 12),
            parentLabel.centerXAnchor.constraint(equalTo: uploadArea.centerXAnchor),

            plusButton.topAnchor.constraint(equalTo: parentLabel.bottomAnchor, constant: 16),
            plusButton.centerXAnchor.constraint(equalTo: uploadArea.centerXAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 36),
            plusButton.heightAnchor.constraint(equalToConstant: 36),

            parentImageView.widthAnchor.constraint(equalTo: uploadArea.widthAnchor),
            parentImageView.heightAnchor.constraint(equalTo: uploadArea.heightAnchor),
            parentImageView.centerXAnchor.constraint(equalTo: uploadArea.centerXAnchor),
            
            orLabel.topAnchor.constraint(equalTo: uploadArea.bottomAnchor, constant: 32),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            chooseLabel.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 4),
            chooseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            exampleStack.topAnchor.constraint(equalTo: chooseLabel.bottomAnchor, constant: 16),
            exampleStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            example1.widthAnchor.constraint(equalToConstant: 72),
            example1.heightAnchor.constraint(equalToConstant: 72),
            example2.widthAnchor.constraint(equalToConstant: 72),
            example2.heightAnchor.constraint(equalToConstant: 72),

            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    // MARK: - IBActions
    @objc private func plusButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc private func continueButtonTapped() {
        // Push a new instance with .second step
        let nextVC = OnboardingBabyViewController(step: .second)
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
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            showUploadedImage(image)
        }
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func showUploadedImage(_ image: UIImage) {
        uploadIcon.isHidden = true
        plusButton.isHidden = true
        parentLabel.isHidden = true
        parentImageView.image = image
    }
}
