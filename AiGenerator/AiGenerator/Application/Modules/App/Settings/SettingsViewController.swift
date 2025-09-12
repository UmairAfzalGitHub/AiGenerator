//
//  SettingsViewController.swift
//  VideoEditor
//
//  Created by Haider on 19/08/2025.
//

import UIKit

// MARK: - Settings Model
struct SettingsItem {
    let icon: String
    let title: String
    let hasChevron: Bool
    
    init(icon: String, title: String, hasChevron: Bool = true) {
        self.icon = icon
        self.title = title
        self.hasChevron = hasChevron
    }
}

struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

// MARK: - Settings Table View Cell
class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appSecondaryBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "next-icon")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(actionImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            // Icon image
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: actionImageView.leadingAnchor, constant: -16),
            
            // Chevron
            actionImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            actionImageView.widthAnchor.constraint(equalToConstant: 16),
            actionImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(with item: SettingsItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        actionImageView.isHidden = !item.hasChevron
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = highlighted ? UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0) : .appSecondaryBackground
        }
    }
}

// MARK: - Settings View Controller
class SettingsViewController: BaseViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let sections: [SettingsSection] = [
        SettingsSection(title: "General", items: [
            SettingsItem(icon: "globe", title: "Language"),
        ]),
        SettingsSection(title: "Others", items: [
            SettingsItem(icon: "square.and.arrow.up", title: "Share", hasChevron: false),
            SettingsItem(icon: "text.document", title: "Privacy Policy", hasChevron: false),
            SettingsItem(icon: "star", title: "Rate Us", hasChevron: false),
            SettingsItem(icon: "mail", title: "Feedback", hasChevron: false),
            SettingsItem(icon: "arrow.up.forward.app", title: "More Apps", hasChevron: false)
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        addBackButton()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Setup navigation
        title = "Settings"
        
        // Add table view
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.rowHeight = 56
        tableView.sectionHeaderHeight = 50
        tableView.sectionFooterHeight = 0
    }
}

// MARK: - Table View Data Source
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = sections[section].title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
}

// MARK: - Table View Delegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = sections[indexPath.section].items[indexPath.row]
        
        // Handle cell selection based on the item
        switch item.title {
        case "Language":
            handleLanguageSelection()
        case "Share":
            handleShareSelection()
        case "Privacy Policy":
            handlePrivacyPolicySelection()
        case "Rate Us":
            handleRateUsSelection()
        case "Feedback":
            handleFeedbackSelection()
        case "More Apps":
            handleMoreAppsSelection()
        default:
            break
        }
    }
    
    // MARK: - Selection Handlers
    private func handleLanguageSelection() {
        let languageVC = LanguageViewController()
        navigationController?.pushViewController(languageVC, animated: true)
    }
    
    private func handleShareSelection() {
        print("Share selected")
        // Handle share functionality
        let activityVC = UIActivityViewController(activityItems: ["Check out this amazing video editor!"], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func handlePrivacyPolicySelection() {
        print("Privacy Policy selected")
        // Handle privacy policy
    }
    
    private func handleRateUsSelection() {
        print("Rate Us selected")
        // Handle rate us functionality
        if let url = URL(string: "https://apps.apple.com/app/id") {
            UIApplication.shared.open(url)
        }
    }
    
    private func handleFeedbackSelection() {
        print("Feedback selected")
        // Handle feedback functionality
    }
    
    private func handleMoreAppsSelection() {
        print("More Apps selected")
        // Handle more apps functionality
    }
}
