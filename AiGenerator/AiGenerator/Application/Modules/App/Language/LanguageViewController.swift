//
//  LanguageSelectionViewController.swift
//
//
//  Created by Haider Rathore on 26/08/2025.
//

import UIKit
import GoogleMobileAds

enum LanguageIntent {
    case onBoarding
    case settings
}

class LanguageViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    var intent: LanguageIntent = .onBoarding
    var selected = String()
    
    private var languages: [Language] = [
        Language(title: "English", flagImage: "english-flag", isSelected: false, languageCode: "en"),
        Language(title: "Arabic", flagImage: "arabic-flag", isSelected: false, languageCode: "ar"),
        Language(title: "Spanish", flagImage: "spanish-flag", isSelected: false, languageCode: "es"),
        Language(title: "Chinese", flagImage: "chinese-flag", isSelected: false, languageCode: "zh-Hans"),
        Language(title: "French", flagImage: "french-flag", isSelected: false, languageCode: "fr"),
        Language(title: "German", flagImage: "german-flag", isSelected: false, languageCode: "de"),
        Language(title: "Russian", flagImage: "russian-flag", isSelected: false, languageCode: "ru"),
        Language(title: "Indonesian", flagImage: "indonesian-flag", isSelected: false, languageCode: "id"),
        Language(title: "Hindi", flagImage: "hindi-flag", isSelected: false, languageCode: "hi"),
        Language(title: "Japanese", flagImage: "japanese-flag", isSelected: false, languageCode: "ja"),
        Language(title: "Korean", flagImage: "korean-flag", isSelected: false, languageCode: "ko"),
        Language(title: "Italian", flagImage: "italian-flag", isSelected: false, languageCode: "it"),
        Language(title: "Malaysian", flagImage: "malay-flag", isSelected: false, languageCode: "ms"),
        Language(title: "Thai", flagImage: "thai-flag", isSelected: false, languageCode: "th"),
        Language(title: "Turkish", flagImage: "turkish-flag", isSelected: false, languageCode: "tr"),
        Language(title: "Vietnamese", flagImage: "vietnamese-flag", isSelected: false, languageCode: "vi"),
    ]
    
    private var selectedIndex: IndexPath?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Select Language"
        setupCollectionView()
        setupLayout()
        setupNavigationButton()
    }
    
    // MARK: - Setup Navigation Button
    private func setupNavigationButton() {
        // Initially hide the button
        navigationItem.rightBarButtonItem = nil
    }
    
    private func updateNavigationButton() {
        if selectedIndex != nil {
            // Show the button when a language is selected
            let selectButton = UIBarButtonItem(
                title: "Select",
                style: .done,
                target: self,
                action: #selector(didTapSelect)
            )
            selectButton.tintColor = .appPrimary
            navigationItem.rightBarButtonItem = selectButton
        } else {
            // Hide the button when no language is selected
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - Setup Collection View
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(LanguageCell.self, forCellWithReuseIdentifier: "LanguageCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func didTapSelect() {
        if let selectedIndex = selectedIndex {
            selectLanguage(indexNo: selectedIndex)
        } else {
            print("No language selected")
            return
        }
        
        if intent == .settings {
            let tabVC = TabBarAppController()
            tabVC.selectedIndex = 1
            UIApplication.shared.updateRootViewController(to: tabVC)
            return
        }
        
        UserDefaults.standard.set(true, forKey: "isOnboardingComplete")
        
        if AdManager.shared.splashInterstitial == true {
            if AdManager.shared.splashInterstitial {
                AdManager.shared.adCounter = AdManager.shared.maxInterstitalAdCounter
            }
            AdManager.shared.showInterstitial(adId: AdMobConfig.interstitial) {
                let navController = TabBarAppController()
                UIApplication.shared.updateRootViewController(to: navController)
            }
        } else {
            let navController = TabBarAppController()
            UIApplication.shared.updateRootViewController(to: navController)
        }
    }
}

// MARK: - CollectionView Delegate & DataSource
extension LanguageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        let lang = languages[indexPath.item]
        cell.configure(with: lang, isSelected: selectedIndex == indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previous = selectedIndex
        selectedIndex = indexPath
        var reloads: [IndexPath] = [indexPath]
        if let prev = previous { reloads.append(prev) }
        collectionView.reloadItems(at: reloads)
        
        // Update navigation button visibility
        updateNavigationButton()
    }
    
    // Grid layout 2 columns
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16) / 2
        return CGSize(width: width, height: 64)
    }
    
    func selectLanguage(indexNo : IndexPath) {
        let diplayLangArray = languages
        
        print(diplayLangArray[indexNo.row].title)
        self.selected = diplayLangArray[indexNo.row].title
        
        LanguageManager.storeCurrentLanguage(code: diplayLangArray[indexNo.row].languageCode)
        UserDefaults.standard.set(diplayLangArray[indexNo.row].title, forKey: "DisplayLang")
        UIView.appearance().semanticContentAttribute = LanguageManager.currentSemantic()
        UINavigationBar.appearance().semanticContentAttribute = LanguageManager.currentSemantic()
    }
}

// MARK: - Custom Cell
class LanguageCell: UICollectionViewCell {
    
    private let cellContentView = UIView()
    private let flagImageView = UIImageView()
    private let nameLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        cellContentView.layer.cornerRadius = 12
        cellContentView.layer.borderColor = UIColor.systemGray.cgColor
        cellContentView.layer.borderWidth = 1
        cellContentView.backgroundColor = .black
        cellContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellContentView)
        
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.clipsToBounds = true
        flagImageView.layer.cornerRadius = 4
        flagImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .white
        
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.isHidden = true
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle")
        checkmarkImageView.tintColor = .appPrimary
        
        let stack = UIStackView(arrangedSubviews: [flagImageView, nameLabel, checkmarkImageView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        
        cellContentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            cellContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            cellContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cellContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            stack.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: cellContentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: cellContentView.bottomAnchor, constant: -8)
        ])
        
        flagImageView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        flagImageView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        checkmarkImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkmarkImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Important: shadow setup on CELL itself
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
    }
    
    func configure(with language: Language, isSelected: Bool) {
        flagImageView.image = UIImage(named: language.flagImage)
        nameLabel.text = language.title
        checkmarkImageView.isHidden = !isSelected
        
        if isSelected {
            cellContentView.layer.borderColor = UIColor.appPrimary.cgColor
            cellContentView.layer.borderWidth = 1.5
            
        } else {
            cellContentView.layer.borderColor = UIColor.systemGray.cgColor
            cellContentView.layer.borderWidth = 1
        }
    }
}
