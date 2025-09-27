import UIKit

protocol BabyGalleryCollectionViewCellDelegate: AnyObject {
    func didTapViewAction(in cell: BabyGalleryCollectionViewCell)
    func didTapShareAction(in cell: BabyGalleryCollectionViewCell)
    func didTapDeleteAction(in cell: BabyGalleryCollectionViewCell)
}

class BabyGalleryCollectionViewCell: UICollectionViewCell {
    static let identifier = "BabyGalleryCollectionViewCell"
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let menuButton = UIButton()
    private let gradientOverlayView = GradientView()
    
    // MARK: - Properties
    private var menuActions: [UIMenuElement] = []
    weak var delegate: BabyGalleryCollectionViewCellDelegate?
    private(set) var currentColor: UIColor?
    private(set) var currentImage: UIImage?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.backgroundColor = nil
    }
    
    // MARK: - Setup
    private func setupViews() {
        // Set up the cell for proper shadow rendering
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Create a shadow view that will sit behind the container
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 16
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.masksToBounds = false
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        
        // Container view setup
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        // Image view setup
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // Gradient overlay setup
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        
        // Menu button setup
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.tintColor = .white
        menuButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        menuButton.layer.cornerRadius = 15
        
        // Setup menu
        setupMenu()
        
        // Add views to hierarchy in correct order
        contentView.addSubview(shadowView)
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(gradientOverlayView)
        containerView.addSubview(menuButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Shadow view constraints
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Container view constraints - same as shadow view
            containerView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            // Image view fills container
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Gradient overlay view - covers the whole container
            gradientOverlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gradientOverlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gradientOverlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gradientOverlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Menu button in top-right corner
            menuButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            menuButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            menuButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupMenu() {
        // Create menu actions
        menuActions = [
            UIAction(title: "View", image: UIImage(systemName: "eye.fill"), handler: { [weak self] _ in
                self?.handleViewAction()
            }),
            UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), handler: { [weak self] _ in
                self?.handleShareAction()
            }),
            UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: { [weak self] _ in
                self?.handleDeleteAction()
            })
        ]
        
        // Create and configure menu
        let menu = UIMenu(title: "", children: menuActions)
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = menu
    }
    
    // MARK: - Configuration
    func configure(with color: UIColor) {
        imageView.image = nil
        imageView.backgroundColor = color
        currentColor = color
        currentImage = nil
    }
    
    func configure(with image: UIImage) {
        imageView.backgroundColor = nil
        imageView.image = image
        currentImage = image
        currentColor = nil
    }
    
    // MARK: - Action Handlers
    private func handleViewAction() {
        delegate?.didTapViewAction(in: self)
    }
    
    private func handleShareAction() {
        delegate?.didTapShareAction(in: self)
    }
    
    private func handleDeleteAction() {
        delegate?.didTapDeleteAction(in: self)
    }
}
