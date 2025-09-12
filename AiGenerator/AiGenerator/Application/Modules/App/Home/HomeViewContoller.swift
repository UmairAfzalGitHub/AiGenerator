//
//  HomeViewContoller.swift
//  AiGenerator
//
//  Created by Umair Afzal on 02/08/2025.
//

import UIKit

class HomeViewContoller: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Section: Add Parents' Photo
    private let addParentsTitle = UILabel()
    private let parentsGrid = UIStackView()
    private let fatherCard = UIView()
    private let motherCard = UIView()
    private let fatherImageView = UIImageView()
    private let motherImageView = UIImageView()
    private let fatherTitle = UILabel()
    private let motherTitle = UILabel()
    private let fatherPlus = UIButton(type: .system)
    private let motherPlus = UIButton(type: .system)
    
    // Section: Baby Name
    private let babyNameTitle = UILabel()
    private let babyNameTextField = UITextField()
    
    // Section: Select Baby's Gender
    private let genderTitle = UILabel()
    private let genderStack = UIStackView()
    private let randomButton = GenderButton()
    private let girlButton = GenderButton()
    private let boyButton = GenderButton()
    
    // Section: Select Ethnicity
    private let ethnicityTitle = UILabel()
    private let ethnicityGrid = UIStackView()
    private var ethnicityButtons: [EthnicityButton] = []
    
    // Bottom: Generate Button (now outside scrollView)
    private let generateButton = GradientActionButton(type: .system)
    
    // MARK: - State
    private enum ParentSlot { case father, mother }
    private var activeSlot: ParentSlot?
    
    private enum Gender { case random, girl, boy }
    private var selectedGender: Gender = .random { didSet { updateGenderSelection() } }
    
    private var selectedEthnicityIndex: Int? { didSet { updateEthnicitySelection() } }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Generate"
        setupNavigationBar()
        setupScrollHierarchy()
        setupParentsSection()
        setupBabyNameSection()
        setupGenderSection()
        setupEthnicitySection()
        setupGenerateButton()
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
            // Note: bottomAnchor will be set in setupGenerateButton() to be above the generate button
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupParentsSection() {
        addParentsTitle.text = "Add Parents' Photo"
        addParentsTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addParentsTitle.textColor = .white
        addParentsTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addParentsTitle)
        
        parentsGrid.axis = .horizontal
        parentsGrid.distribution = .fillEqually
        parentsGrid.alignment = .fill
        parentsGrid.spacing = 12
        parentsGrid.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(parentsGrid)
        
        configureParentCard(card: fatherCard,
                            imageView: fatherImageView,
                            titleLabel: fatherTitle,
                            plusButton: fatherPlus,
                            title: "Father's Photo",
                            action: #selector(fatherAddTapped))
        configureParentCard(card: motherCard,
                            imageView: motherImageView,
                            titleLabel: motherTitle,
                            plusButton: motherPlus,
                            title: "Mother's Photo",
                            action: #selector(motherAddTapped))
        parentsGrid.addArrangedSubview(fatherCard)
        parentsGrid.addArrangedSubview(motherCard)
        
        NSLayoutConstraint.activate([
            addParentsTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            addParentsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addParentsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            parentsGrid.topAnchor.constraint(equalTo: addParentsTitle.bottomAnchor, constant: 12),
            parentsGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            parentsGrid.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            parentsGrid.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func configureParentCard(card: UIView, imageView: UIImageView, titleLabel: UILabel, plusButton: UIButton, title: String, action: Selector) {
        card.backgroundColor = UIColor(white: 0.12, alpha: 1)
        card.layer.cornerRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(imageView)
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(white: 0.85, alpha: 1)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let personIcon = UIImageView(image: UIImage(systemName: "person.circle"))
        personIcon.tintColor = UIColor(white: 0.6, alpha: 1)
        personIcon.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(personIcon)
        
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.tintColor = .white
        plusButton.backgroundColor = UIColor(white: 0.18, alpha: 1)
        plusButton.layer.cornerRadius = 20
        plusButton.addTarget(self, action: action, for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8),
            
            personIcon.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            personIcon.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            personIcon.widthAnchor.constraint(equalToConstant: 28),
            personIcon.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.leadingAnchor.constraint(equalTo: personIcon.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: personIcon.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -16),
            
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            plusButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            plusButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14)
        ])
    }
    
    private func setupBabyNameSection() {
        babyNameTitle.text = "Baby Name"
        babyNameTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        babyNameTitle.textColor = .white
        babyNameTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(babyNameTitle)
        
        babyNameTextField.placeholder = "Baby Emma"
        babyNameTextField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        babyNameTextField.textColor = .white
        babyNameTextField.backgroundColor = UIColor(white: 0.12, alpha: 1)
        babyNameTextField.layer.cornerRadius = 16
        babyNameTextField.layer.borderWidth = 0
        
        // Configure placeholder color
        babyNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Baby Emma",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0.6, alpha: 1)]
        )
        
        // Add padding to text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: babyNameTextField.frame.height))
        babyNameTextField.leftView = paddingView
        babyNameTextField.leftViewMode = .always
        babyNameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: babyNameTextField.frame.height))
        babyNameTextField.rightViewMode = .always
        
        babyNameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(babyNameTextField)
        
        NSLayoutConstraint.activate([
            babyNameTitle.topAnchor.constraint(equalTo: parentsGrid.bottomAnchor, constant: 36),
            babyNameTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            babyNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            babyNameTextField.topAnchor.constraint(equalTo: babyNameTitle.bottomAnchor, constant: 12),
            babyNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            babyNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            babyNameTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupGenderSection() {
        genderTitle.text = "Select Baby's Gender"
        genderTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        genderTitle.textColor = .white
        genderTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genderTitle)
        
        genderStack.axis = .vertical
        genderStack.spacing = 12
        genderStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genderStack)
        
        randomButton.configure(text: "Surprise Me", systemIcon: "sparkles", isSelected: true)
        girlButton.configure(text: "Girl", systemIcon: "f.circle")
        boyButton.configure(text: "Boy", systemIcon: "m.circle")
        
        randomButton.addTarget(self, action: #selector(randomTapped), for: .touchUpInside)
        girlButton.addTarget(self, action: #selector(girlTapped), for: .touchUpInside)
        boyButton.addTarget(self, action: #selector(boyTapped), for: .touchUpInside)
        
        let topRow = UIStackView(arrangedSubviews: [randomButton])
        topRow.axis = .horizontal
        topRow.distribution = .fillEqually
        topRow.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomRow = UIStackView(arrangedSubviews: [girlButton, boyButton])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 12
        bottomRow.distribution = .fillEqually
        bottomRow.translatesAutoresizingMaskIntoConstraints = false
        
        genderStack.addArrangedSubview(topRow)
        genderStack.addArrangedSubview(bottomRow)
        
        NSLayoutConstraint.activate([
            genderTitle.topAnchor.constraint(equalTo: babyNameTextField.bottomAnchor, constant: 36),
            genderTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genderTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            genderStack.topAnchor.constraint(equalTo: genderTitle.bottomAnchor, constant: 12),
            genderStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genderStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        randomButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        girlButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        boyButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func setupEthnicitySection() {
        ethnicityTitle.text = "Select Ethnicity"
        ethnicityTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        ethnicityTitle.textColor = .white
        ethnicityTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ethnicityTitle)
        
        ethnicityGrid.axis = .vertical
        ethnicityGrid.spacing = 12
        ethnicityGrid.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ethnicityGrid)
        
        let options = ["Caucasian", "Asian", "African", "Hispanic", "Arab", "Indian","Native American", "Latino", "Mediterranean", "Slavic"]
        var row: UIStackView?
        for (idx, title) in options.enumerated() {
            let pill = EthnicityButton()
            pill.configure(text: title)
            pill.tag = idx
            pill.addTarget(self, action: #selector(ethnicityTapped(_:)), for: .touchUpInside)
            ethnicityButtons.append(pill)
            if idx % 2 == 0 {
                row = UIStackView()
                row?.axis = .horizontal
                row?.spacing = 12
                row?.distribution = .fillEqually
                row?.translatesAutoresizingMaskIntoConstraints = false
                ethnicityGrid.addArrangedSubview(row!)
            }
            row?.addArrangedSubview(pill)
            pill.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }
        
        NSLayoutConstraint.activate([
            ethnicityTitle.topAnchor.constraint(equalTo: genderStack.bottomAnchor, constant: 36),
            ethnicityTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ethnicityTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ethnicityGrid.topAnchor.constraint(equalTo: ethnicityTitle.bottomAnchor, constant: 12),
            ethnicityGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ethnicityGrid.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            // Set bottom constraint with padding for content
            ethnicityGrid.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupGenerateButton() {
        generateButton.setTitle("Generate Baby", for: .normal)
        generateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        generateButton.setTitleColor(.white, for: .normal)
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button directly to the main view (not contentView)
        view.addSubview(generateButton)
        
        NSLayoutConstraint.activate([
            // Position the button at the bottom of the screen
            generateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            generateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            generateButton.heightAnchor.constraint(equalToConstant: 56),
            generateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Constrain scrollView to end above the generate button
            scrollView.bottomAnchor.constraint(equalTo: generateButton.topAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    @objc private func fatherAddTapped() {
        activeSlot = .father
        presentPicker()
    }
    
    @objc private func motherAddTapped() {
        activeSlot = .mother
        presentPicker()
    }
    
    private func presentPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc private func randomTapped() { selectedGender = .random }
    @objc private func girlTapped() { selectedGender = .girl }
    @objc private func boyTapped() { selectedGender = .boy }
    
    @objc private func ethnicityTapped(_ sender: EthnicityButton) {
        selectedEthnicityIndex = sender.tag
    }
    
    private func updateGenderSelection() {
        randomButton.isPicked = (selectedGender == .random)
        girlButton.isPicked = (selectedGender == .girl)
        boyButton.isPicked = (selectedGender == .boy)
    }
    
    private func updateEthnicitySelection() {
        for (idx, btn) in ethnicityButtons.enumerated() {
            btn.isPicked = (idx == selectedEthnicityIndex)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let img = info[.originalImage] as? UIImage else { return }
        switch activeSlot {
        case .father:
            fatherImageView.image = img
        case .mother:
            motherImageView.image = img
        case .none:
            break
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UI Helpers

// Gender Button - with icon support
private class GenderButton: UIControl {
    private let container = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    
    var isPicked: Bool = false { didSet { refresh() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func configure(text: String, systemIcon: String, isSelected: Bool = false) {
        titleLabel.text = text
        iconView.image = UIImage(systemName: systemIcon)
        isPicked = isSelected
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        
        checkmark.tintColor = UIColor(red: 255/255, green: 153/255, blue: 221/255, alpha: 1)
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(checkmark)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            checkmark.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            checkmark.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 22),
            checkmark.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        refresh()
    }
    
    private func refresh() {
        if isPicked {
            container.layer.borderWidth = 2
            container.layer.borderColor = UIColor(red: 255/255, green: 153/255, blue: 221/255, alpha: 1).cgColor
            container.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 221/255, alpha: 0.1)
            container.layer.cornerRadius = 18
            checkmark.isHidden = false
        } else {
            container.layer.borderWidth = 0
            container.layer.borderColor = UIColor.clear.cgColor
            container.backgroundColor = UIColor(white: 0.12, alpha: 1)
            container.layer.cornerRadius = 16
            checkmark.isHidden = true
        }
    }
}

// Ethnicity Button - without icon, text only
private class EthnicityButton: UIControl {
    private let container = UIView()
    private let titleLabel = UILabel()
    private let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    
    var isPicked: Bool = false { didSet { refresh() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func configure(text: String, isSelected: Bool = false) {
        titleLabel.text = text
        isPicked = isSelected
    }
    
    private func setup() {
        container.backgroundColor = UIColor(white: 0.12, alpha: 1)
        container.layer.cornerRadius = 16
        container.isUserInteractionEnabled = false
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        
        checkmark.tintColor = UIColor(red: 255/255, green: 153/255, blue: 221/255, alpha: 1)
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(checkmark)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: checkmark.leadingAnchor, constant: -8),
            
            checkmark.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            checkmark.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 22),
            checkmark.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        refresh()
    }
    
    private func refresh() {
        if isPicked {
            container.layer.borderWidth = 2
            container.layer.borderColor = UIColor(red: 255/255, green: 153/255, blue: 221/255, alpha: 1).cgColor
            container.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 221/255, alpha: 0.1)
            container.layer.cornerRadius = 18
            checkmark.isHidden = false
        } else {
            container.layer.borderWidth = 0
            container.layer.borderColor = UIColor.clear.cgColor
            container.backgroundColor = UIColor(white: 0.12, alpha: 1)
            container.layer.cornerRadius = 16
            checkmark.isHidden = true
        }
    }
}

private class GradientActionButton: UIButton {
    private let gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 28
        clipsToBounds = true
        gradient.colors = [
            UIColor(red: 94/255, green: 150/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 153/255, blue: 221/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradient, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
}
