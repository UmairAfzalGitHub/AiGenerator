//
//  AgingViewController.swift
//  AiGenerator
//
//  Created by Haider on 12/09/2025.
//

import UIKit

class ExploreViewController: BaseViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var babyGeneratorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AI Baby Generator"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var babyGeneratorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.12, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AI Baby Aging Generator"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var agingGeneratorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.12, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var fantasyThemesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fantasy Themes"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var fantasyThemesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.12, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var schoolPhotosLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "School Photos"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var schoolPhotosView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.12, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var festivalsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Festivals"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var festivalsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.12, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()

    private lazy var sportsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sports"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var sportsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.12, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var professionalHeadshotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Professional Headshot Portraits"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var professionalHeadshotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.12, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Explore"
        setupNavigationBar()
        setupUI()
        setupCategoryRows()
    }
    
    func setupUI() {
        // Add scroll view to main view
        view.addSubview(scrollView)
        
        // Add content view to scroll view
        scrollView.addSubview(contentView)
        
        // Add all content to content view
        contentView.addSubview(babyGeneratorLabel)
        contentView.addSubview(babyGeneratorView)
        contentView.addSubview(ageLabel)
        contentView.addSubview(agingGeneratorView)
        contentView.addSubview(fantasyThemesLabel)
        contentView.addSubview(fantasyThemesView)
        contentView.addSubview(schoolPhotosLabel)
        contentView.addSubview(schoolPhotosView)
        contentView.addSubview(festivalsLabel)
        contentView.addSubview(festivalsView)
        contentView.addSubview(sportsLabel)
        contentView.addSubview(sportsView)
        contentView.addSubview(professionalHeadshotLabel)
        contentView.addSubview(professionalHeadshotView)
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Content constraints
            babyGeneratorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            babyGeneratorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            babyGeneratorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            babyGeneratorView.topAnchor.constraint(equalTo: babyGeneratorLabel.bottomAnchor, constant: 16),
            babyGeneratorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            babyGeneratorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            babyGeneratorView.heightAnchor.constraint(equalToConstant: 150),
            
            ageLabel.topAnchor.constraint(equalTo: babyGeneratorView.bottomAnchor, constant: 32),
            ageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            agingGeneratorView.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 16),
            agingGeneratorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            agingGeneratorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            agingGeneratorView.heightAnchor.constraint(equalToConstant: 150),
            
            fantasyThemesLabel.topAnchor.constraint(equalTo: agingGeneratorView.bottomAnchor, constant: 32),
            fantasyThemesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fantasyThemesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            fantasyThemesView.topAnchor.constraint(equalTo: fantasyThemesLabel.bottomAnchor, constant: 16),
            fantasyThemesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fantasyThemesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            fantasyThemesView.heightAnchor.constraint(equalToConstant: 150),
            
            festivalsLabel.topAnchor.constraint(equalTo: fantasyThemesView.bottomAnchor, constant: 32),
            festivalsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            festivalsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            festivalsView.topAnchor.constraint(equalTo: festivalsLabel.bottomAnchor, constant: 16),
            festivalsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            festivalsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            festivalsView.heightAnchor.constraint(equalToConstant: 150),
            
            schoolPhotosLabel.topAnchor.constraint(equalTo: festivalsView.bottomAnchor, constant: 32),
            schoolPhotosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            schoolPhotosLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            schoolPhotosView.topAnchor.constraint(equalTo: schoolPhotosLabel.bottomAnchor, constant: 16),
            schoolPhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            schoolPhotosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            schoolPhotosView.heightAnchor.constraint(equalToConstant: 150),
            
            sportsLabel.topAnchor.constraint(equalTo: schoolPhotosView.bottomAnchor, constant: 32),
            sportsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sportsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            sportsView.topAnchor.constraint(equalTo: sportsLabel.bottomAnchor, constant: 16),
            sportsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sportsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sportsView.heightAnchor.constraint(equalToConstant: 150),

            professionalHeadshotLabel.topAnchor.constraint(equalTo: sportsView.bottomAnchor, constant: 32),
            professionalHeadshotLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            professionalHeadshotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            professionalHeadshotView.topAnchor.constraint(equalTo: professionalHeadshotLabel.bottomAnchor, constant: 16),
            professionalHeadshotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            professionalHeadshotView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            professionalHeadshotView.heightAnchor.constraint(equalToConstant: 150),
            
            // Important: Bottom constraint to ensure proper scrolling
            professionalHeadshotView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    // MARK: - Category Rows with ScrollableStackView
    private func setupCategoryRows() {
        // Festivals
        let festivalItems = [
            "Christmas",
            "Eid",
            "Diwali",
            "Halloween",
            "Easter",
            "Birthday",
            "New Year’s",
            "Thanksgiving"
        ]
        addScrollableRow(into: festivalsView, items: festivalItems)

        // Fantasy Themes
        let fantasyItems = [
            "Prince / Princess",
            "Astronaut",
            "Time Traveler",
            "Fairy / Elf",
            "Knight in Armor",
            "Pirate",
            "Wizard / Witch",
            "Dragon Rider"
        ]
        addScrollableRow(into: fantasyThemesView, items: fantasyItems)

        // School Photos
        let schoolItems = [
            "Kindergarten \nUniform",
            "School \nUniform",
            "High School \nStudent",
            "Graduation \nGown & Cap",
            "Classroom \nPose",
            "School \nPhoto Day"
        ]
        addScrollableRow(into: schoolPhotosView, items: schoolItems)

        // Sports
        let sportsItems = [
            "Football/Soccer",
            "Cricket",
            "Basketball",
            "Baseball",
            "Tennis",
            "Swimming",
            "Martial Arts",
            "Cycling"
        ]
        addScrollableRow(into: sportsView, items: sportsItems)
    }

    private func addScrollableRow(into container: UIView, items: [String]) {
        let stackScroll = ScrollableStackView()
        stackScroll.axis = .horizontal
        stackScroll.alignment = .fill
        stackScroll.distribution = .fill
        stackScroll.spacing = 12
        stackScroll.disableIntrinsicContentSizeScrolling = true

        container.addSubview(stackScroll)
        NSLayoutConstraint.activate([
            stackScroll.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stackScroll.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stackScroll.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stackScroll.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        // Build item cards
        let cards: [UIView] = items.map { buildItemCard(title: $0) }
        cards.forEach { card in
            stackScroll.addArrangedSubview(card)
            NSLayoutConstraint.activate([
                card.heightAnchor.constraint(equalTo: stackScroll.heightAnchor),
                card.widthAnchor.constraint(equalTo: card.heightAnchor),
            ])
        }
    }

    private func buildItemCard(title: String) -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(white: 0.18, alpha: 1)
        card.layer.cornerRadius = 12
        card.layer.masksToBounds = true

        // Placeholder inner view (e.g., image area)
        let inner = UIView()
        inner.translatesAutoresizingMaskIntoConstraints = false
        inner.backgroundColor = UIColor(white: 0.22, alpha: 1)
        card.addSubview(inner)

        let labelView = UIView()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        labelView.layer.cornerRadius = 6
        labelView.clipsToBounds = true
        card.addSubview(labelView)

        // Bottom-right label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 2
        labelView.addSubview(label)

        NSLayoutConstraint.activate([
            // inner fills the card
            inner.topAnchor.constraint(equalTo: card.topAnchor),
            inner.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            inner.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            inner.bottomAnchor.constraint(equalTo: card.bottomAnchor),

            // position labelView at bottom-left, allow it to size to its content
            labelView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            labelView.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -8),
            labelView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8),


            // pin label inside labelView with padding so labelView's size is driven by the label
            label.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -6),
            label.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -4)
        ])

        return card
    }
}
