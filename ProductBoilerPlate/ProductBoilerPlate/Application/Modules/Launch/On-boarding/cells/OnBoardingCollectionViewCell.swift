//
//  OnBoardingCollectionViewCell.swift
//  OnBoarding
//
//  Created by Umair Afzal on 03/02/2019.
//  Copyright © 2019 Umair Afzal. All rights reserved.
//

import UIKit
import Lottie

class OnBoardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var headingLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headingLabel.textColor = .white
        descriptionLabel.textColor = .white
        headingLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15.0)
        
        if UIDevice().isSmallerDevice() {
            headingLabelTopConstraint.constant = 0
            imageViewCenterYConstraint.constant = -50
        }
    }

    func setupCell(data: OnBoarding, isLastCell: Bool = false) {
        topImageView.image = data.topImage
        headingLabel.text = data.heading
        descriptionLabel.text = data.description
        
        // Show animation only if it's the last cell
        animationView.isHidden = !isLastCell
        
        if isLastCell && !animationView.isAnimationPlaying {
            animationView.loopMode = .loop
            animationView.play()
        } else if !isLastCell && animationView.isAnimationPlaying {
            animationView.stop()
        }
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> OnBoardingCollectionViewCell {
        let kOnBoardingCollectionViewCellIdentifier = "kOnBoardingCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "OnBoardingCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kOnBoardingCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kOnBoardingCollectionViewCellIdentifier, for: indexPath) as! OnBoardingCollectionViewCell
        return cell
    }
}
