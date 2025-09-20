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
    
    private lazy var superheroLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Superhero / Cartoon Style"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var superheroView: UIView = {
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
        contentView.addSubview(superheroLabel)
        contentView.addSubview(superheroView)
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
            
            schoolPhotosLabel.topAnchor.constraint(equalTo: fantasyThemesView.bottomAnchor, constant: 32),
            schoolPhotosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            schoolPhotosLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            schoolPhotosView.topAnchor.constraint(equalTo: schoolPhotosLabel.bottomAnchor, constant: 16),
            schoolPhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            schoolPhotosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            schoolPhotosView.heightAnchor.constraint(equalToConstant: 150),
            
            superheroLabel.topAnchor.constraint(equalTo: schoolPhotosView.bottomAnchor, constant: 32),
            superheroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            superheroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            superheroView.topAnchor.constraint(equalTo: superheroLabel.bottomAnchor, constant: 16),
            superheroView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            superheroView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            superheroView.heightAnchor.constraint(equalToConstant: 150),
            
            professionalHeadshotLabel.topAnchor.constraint(equalTo: superheroView.bottomAnchor, constant: 32),
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
}
