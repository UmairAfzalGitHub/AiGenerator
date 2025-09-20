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
    
    init(rows: Int = 3, rowSpacing: CGFloat = 16) {
        self.rows = rows
        self.rowSpacing = rowSpacing
        super.init(frame: .zero)
        setupStackView()
        setupCollectionViews()
        startAutoScroll()
    }
    
    required init?(coder: NSCoder) {
        self.rows = 3
        self.rowSpacing = 16
        super.init(coder: coder)
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
            layout.minimumLineSpacing = 20
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
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        cell.configure()
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.bounds.height
        guard height > 0 else { return CGSize(width: 50, height: 50) }
        return CGSize(width: height, height: height) // square
    }
}
