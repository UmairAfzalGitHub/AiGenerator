//
//  BabyGalleryViewController.swift
//  AiGenerator
//
//  Created by Haider on 12/09/2025.
//

import UIKit

class BabyGalleryViewController: BaseViewController {

    private let noDataContentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Baby Gallery"
        setupNavigationBar()
    }
}
