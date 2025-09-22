//
//  GridCell.swift
//  AiGenerator
//
//  Created by Umair Afzal on 20/09/2025.
//

import Foundation
import UIKit

class GridCell: UICollectionViewCell {
    private let coloredView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coloredView)
        coloredView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            coloredView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coloredView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coloredView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coloredView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Pin imageView with 0 constraints to fill the coloredView
            imageView.topAnchor.constraint(equalTo: coloredView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: coloredView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(imageName: String? = nil) {
        if let imageName = imageName, let image = UIImage(named: imageName) {
            imageView.image = image
            coloredView.backgroundColor = .clear
        } else {
            imageView.image = nil
            coloredView.backgroundColor = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
        }
    }
}

