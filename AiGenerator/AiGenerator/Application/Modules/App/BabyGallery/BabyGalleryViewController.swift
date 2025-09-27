//
//  BabyGalleryViewController.swift
//  AiGenerator
//
//  Created by Haider on 12/09/2025.
//

import UIKit
import os.log

class BabyGalleryViewController: BaseViewController {

    // MARK: - UI Elements
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: BabyGalleryViewController.createLayout())
    private let noDataContentView = UIView()
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, BabyHistoryItem>?
    private var historyItems: [BabyHistoryItem] = []
    
    // MARK: - Enums
    enum Section: Int, CaseIterable {
        case main
    }

    
    // MARK: - Lifecycle
    private let logger = Logger(subsystem: "com.aiGenerator.app", category: "BabyGalleryViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Baby Gallery"
        view.backgroundColor = .black
        setupNavigationBar()
        setupCollectionView()
        setupNoDataView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHistoryData()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.register(BabyGalleryCollectionViewCell.self, forCellWithReuseIdentifier: BabyGalleryCollectionViewCell.identifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNoDataView() {
        noDataContentView.translatesAutoresizingMaskIntoConstraints = false
        noDataContentView.isHidden = true
        view.addSubview(noDataContentView)
        
        let imageView = UIImageView(image: UIImage(systemName: "photo.on.rectangle.angled"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "No babies in your gallery yet"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        noDataContentView.addSubview(imageView)
        noDataContentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            noDataContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataContentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            noDataContentView.heightAnchor.constraint(equalToConstant: 200),
            
            imageView.topAnchor.constraint(equalTo: noDataContentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: noDataContentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: noDataContentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: noDataContentView.trailingAnchor),
            label.bottomAnchor.constraint(lessThanOrEqualTo: noDataContentView.bottomAnchor)
        ])
    }
    
    // MARK: - Collection View Layout
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // Define item sizes for our mosaic layout
            let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
            largeItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Create different group arrangements for visual interest
            
            // Two small items side by side
            let smallItemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            let smallItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: smallItemGroupSize, subitems: [smallItem, smallItem])
            
            // One large item
            let largeItemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.75))
            let largeItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: largeItemGroupSize, subitems: [largeItem])
            
            // Asymmetric group: one large item (2/3) and two small items stacked (1/3)
            let asymmetricItemSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.66), heightDimension: .fractionalHeight(1.0))
            let asymmetricItem1 = NSCollectionLayoutItem(layoutSize: asymmetricItemSize1)
            asymmetricItem1.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let asymmetricItemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
            let asymmetricItem2 = NSCollectionLayoutItem(layoutSize: asymmetricItemSize2)
            asymmetricItem2.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let asymmetricGroupSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.34), heightDimension: .fractionalHeight(1.0))
            let asymmetricGroup2 = NSCollectionLayoutGroup.vertical(layoutSize: asymmetricGroupSize2, subitems: [asymmetricItem2, asymmetricItem2])
            
            let asymmetricGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.75))
            let asymmetricGroup = NSCollectionLayoutGroup.horizontal(layoutSize: asymmetricGroupSize, subitems: [asymmetricItem1, asymmetricGroup2])
            
            // Combine all these groups into a mega group that repeats
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1000))
            let nestedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: nestedGroupSize,
                subitems: [smallItemGroup, largeItemGroup, asymmetricGroup, smallItemGroup]
            )
            
            // Create the section with the nested group
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
        
        return layout
    }
    
    // MARK: - Data Source
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, BabyHistoryItem>(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BabyGalleryCollectionViewCell.identifier,
                        for: indexPath
                      ) as? BabyGalleryCollectionViewCell else {
                    return nil
                }
                
                // Load image for this history item
                if let image = HistoryManager.shared.loadImage(for: item) {
                    cell.configure(with: image)
                } else {
                    // Fallback to a placeholder color if image can't be loaded
                    cell.configure(with: self.generateRandomColor())
                }
                
                cell.delegate = self
                return cell
            }
        )
    }
    
    // MARK: - Data Loading
    private func loadHistoryData() {
        logger.info("📋 Loading baby history data")
        
        // Get all history items from HistoryManager
        historyItems = HistoryManager.shared.getAllHistoryItems()
        
        // Apply snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, BabyHistoryItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(historyItems, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        // Show/hide no data view
        noDataContentView.isHidden = !historyItems.isEmpty
        collectionView.isHidden = historyItems.isEmpty
        
        if historyItems.isEmpty {
            logger.info("ℹ️ No history items found")
        } else {
            logger.info("✅ Loaded \(self.historyItems.count) history items")
        }
    }
    
    // MARK: - Helper Methods
    private func generateRandomColor() -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 0.95, green: 0.61, blue: 0.73, alpha: 1.0), // Pink
            UIColor(red: 0.56, green: 0.76, blue: 0.87, alpha: 1.0), // Light Blue
            UIColor(red: 0.98, green: 0.83, blue: 0.65, alpha: 1.0), // Peach
            UIColor(red: 0.77, green: 0.87, blue: 0.65, alpha: 1.0), // Light Green
            UIColor(red: 0.67, green: 0.61, blue: 0.87, alpha: 1.0), // Purple
            UIColor(red: 0.87, green: 0.68, blue: 0.87, alpha: 1.0), // Lavender
            UIColor(red: 0.56, green: 0.83, blue: 0.83, alpha: 1.0), // Turquoise
            UIColor(red: 0.95, green: 0.76, blue: 0.56, alpha: 1.0)  // Coral
        ]
        
        return colors.randomElement() ?? .systemBlue
    }
}

// MARK: - Models
struct BabyItem: Hashable {
    let id: String
    let color: UIColor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: BabyItem, rhs: BabyItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - UICollectionViewDelegate
extension BabyGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        // Load the image for this history item
        if let image = HistoryManager.shared.loadImage(for: item) {
            // Open ResultViewController with the image and baby name
            let resultVC = ResultViewController(image: image, name: item.babyName)
            navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}

// MARK: - BabyGalleryCollectionViewCellDelegate
extension BabyGalleryViewController: BabyGalleryCollectionViewCellDelegate {
    func didTapViewAction(in cell: BabyGalleryCollectionViewCell) {
        // Get image to display
        let imageToDisplay: UIImage
        
        if let image = cell.currentImage {
            imageToDisplay = image
        } else if let color = cell.currentColor {
            // Create a placeholder image with the cell's color
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1000, height: 1000))
            imageToDisplay = renderer.image { context in
                color.setFill()
                context.fill(CGRect(x: 0, y: 0, width: 1000, height: 1000))
            }
        } else {
            return
        }
        
        // Present the full screen view controller
        let fullScreenVC = FullScreenImageViewController(image: imageToDisplay)
        present(fullScreenVC, animated: true)
    }
    
    func didTapShareAction(in cell: BabyGalleryCollectionViewCell) {
        // Get image to share
        let imageToShare: UIImage
        
        if let image = cell.currentImage {
            imageToShare = image
        } else if let color = cell.currentColor {
            // Create a placeholder image with the cell's color
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1000, height: 1000))
            imageToShare = renderer.image { context in
                color.setFill()
                context.fill(CGRect(x: 0, y: 0, width: 1000, height: 1000))
            }
        } else {
            return
        }
        
        // Present share sheet
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        // For iPad, set the source view to prevent crash
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = cell
            popoverController.sourceRect = cell.bounds
        }
        
        present(activityVC, animated: true)
    }
    
    func didTapDeleteAction(in cell: BabyGalleryCollectionViewCell) {
        // Find the index path for the cell
        guard let indexPath = collectionView.indexPath(for: cell),
              let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        
        // Show confirmation alert
        let alert = UIAlertController(
            title: "Delete Baby Image",
            message: "Are you sure you want to delete this baby image? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteHistoryItem(item)
        })
        
        present(alert, animated: true)
    }
    
    private func deleteHistoryItem(_ item: BabyHistoryItem) {
        logger.info("🗑️ Deleting history item with ID: \(item.id)")
        
        // Delete from HistoryManager
        HistoryManager.shared.deleteHistoryItem(item) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.logger.info("✅ Successfully deleted history item")
                
                // Remove item from UI
                DispatchQueue.main.async {
                    // Update data source
                    var snapshot = self.dataSource?.snapshot()
                    snapshot?.deleteItems([item])
                    
                    if let snapshot = snapshot {
                        self.dataSource?.apply(snapshot, animatingDifferences: true)
                        
                        // Update history items array
                        if let index = self.historyItems.firstIndex(where: { $0.id == item.id }) {
                            self.historyItems.remove(at: index)
                        }
                        
                        // Show/hide no data view if needed
                        self.noDataContentView.isHidden = !self.historyItems.isEmpty
                        self.collectionView.isHidden = self.historyItems.isEmpty
                    }
                }
                
            case .failure(let error):
                self.logger.error("❌ Failed to delete history item: \(error.localizedDescription)")
                
                // Show error alert
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Delete Failed",
                        message: "Failed to delete the baby image. Please try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
