//
//  UIApplication.swift
//  Photo Recovery
//
//  Created by Umair Afzal on 21/05/2025.
//

import Foundation
import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: \.isKeyWindow)
    }
}
