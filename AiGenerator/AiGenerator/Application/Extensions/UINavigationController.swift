//
//  UINavigationController.swift
//  Photo Recovery
//
//  Created by Haider Rathore on 29/04/2025.
//

import UIKit

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
