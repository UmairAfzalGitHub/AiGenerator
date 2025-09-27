//
//  GridView.swift
//  AiGenerator
//
//  Created by Umair Afzal on 20/09/2025.
//

import Foundation
import UIKit

class GridView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let rows: Int
    private let rowSpacing: CGFloat
    private let stackView = UIStackView()
    private var collectionViews: [UICollectionView] = []
    private var displayLink: CADisplayLink?
    
    // Image names data source
    private var imageNames: [String] = []
    
    // Store randomized image names for each row
    private var rowImageNames: [[String]] = []
    
    init(rows: Int = 2, rowSpacing: CGFloat = 4) { // Fewer rows, tighter spacing
        self.rows = rows
        self.rowSpacing = rowSpacing
        super.init(frame: .zero)
        generateImageNames()
        setupStackView()
        setupCollectionViews()
        startAutoScroll()
    }
    
    required init?(coder: NSCoder) {
        self.rows = 2
        self.rowSpacing = 4 // Fewer rows, tighter spacing
        super.init(coder: coder)
        generateImageNames()
        setupStackView()
        setupCollectionViews()
        startAutoScroll()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = rowSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCollectionViews() {
        for _ in 0..<rows {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 4 // Reduced spacing between images
            layout.minimumInteritemSpacing = 0
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
            
            stackView.addArrangedSubview(collectionView)
            collectionViews.append(collectionView)
            
            collectionView.heightAnchor.constraint(equalTo: heightAnchor,
                                                   multiplier: 1 / CGFloat(rows),
                                                   constant: -(rowSpacing * CGFloat(rows - 1) / CGFloat(rows))
            ).isActive = true
        }
    }
    
    private func startAutoScroll() {
        displayLink = CADisplayLink(target: self, selector: #selector(handleAutoScroll))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func handleAutoScroll() {
        for (index, collectionView) in collectionViews.enumerated() {
            let direction: CGFloat = (index % 2 == 0) ? 1 : -1 // alternate directions
            let offsetX = collectionView.contentOffset.x + direction * 0.5 // adjust speed here
            
            let maxOffsetX = collectionView.contentSize.width - collectionView.bounds.width
            if offsetX < 0 {
                collectionView.contentOffset.x = maxOffsetX
            } else if offsetX > maxOffsetX {
                collectionView.contentOffset.x = 0
            } else {
                collectionView.contentOffset.x = offsetX
            }
        }
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If we have randomized arrays, use their count, otherwise fall back to imageNames
        if let rowIndex = collectionViews.firstIndex(of: collectionView), rowIndex < rowImageNames.count {
            return rowImageNames[rowIndex].count
        }
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        
        // Get the appropriate image name based on which collection view this is
        var imageName: String
        if let rowIndex = collectionViews.firstIndex(of: collectionView), rowIndex < rowImageNames.count {
            let rowImages = rowImageNames[rowIndex]
            imageName = rowImages[indexPath.item % rowImages.count]
        } else {
            imageName = imageNames[indexPath.item % imageNames.count]
        }
        
        cell.configure(imageName: imageName)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.bounds.height
        guard height > 0 else { return CGSize(width: 120, height: 120) } // Larger fallback size
        
        // Keep images complete by using the full row height (no multiplier > 1)
        // Images will be larger because we have fewer rows now
        return CGSize(width: height, height: height) // Perfect square, no clipping
    }
    
    // MARK: - Image Names Generation
    
    private func generateImageNames() {
        // Generate baby image names from baby-1 to baby-20
        imageNames.removeAll()
        rowImageNames.removeAll()
        
        for i in 1...30 {
            imageNames.append("baby-\(i)")
        }
        
        // Create randomized arrays for each row
        for _ in 0..<rows {
            var rowImages = imageNames
            rowImages.shuffle() // Randomize the order
            rowImageNames.append(rowImages)
        }
    }
}
