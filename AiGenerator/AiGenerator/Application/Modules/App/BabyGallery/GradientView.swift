import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        // Configure gradient - from transparent to black
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradientLayer.locations = [0.0, 0.6, 0.8, 1.0]
        
        // Set gradient direction (top to bottom)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // Add gradient to view
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient frame when view size changes
        gradientLayer.frame = bounds
    }
}
