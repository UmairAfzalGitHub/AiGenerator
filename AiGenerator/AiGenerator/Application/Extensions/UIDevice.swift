//
//  UIDevice.swift
//  Photo Recovery
//
//  Created by Umair Afzal on 16/05/2025.
//

import Foundation

import UIKit

extension UIDevice {
    var isSmallDevice: Bool {
        // Screen height ≤ 667 includes: iPhone SE (1st/2nd/3rd gen), iPhone 6/7/8
        let screenHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return screenHeight <= 667
    }
    
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
