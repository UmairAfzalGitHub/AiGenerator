//
//  UIFont.swift
//  Photo Recovery
//
//  Created by Umair Afzal on 07/03/2025.
//

import Foundation
import UIKit

extension UIFont {
    
    class func regular(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-Regular", size: size)
    }
    
    class func bold(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-Bold", size: size)
    }
    
    class func extraBold(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-ExtraBold", size: size)
    }
    
    class func extraBoldItalic(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-ExtraBoldItalic", size: size)
    }
    
    class func extraLight(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-ExtraLight", size: size)
    }

    class func extraLightItalic(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-ExtraLightItalic", size: size)
    }
    
    class func italic(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-Italic", size: size)
    }
    
    class func light(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-Light", size: size)
    }
    
    class func lightItalic(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-LightItalic", size: size)
    }
    
    class func medium(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-Medium", size: size)
    }

    class func mediumItalic(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-MediumItalic", size: size)
    }
    
    class func semiBold(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-SemiBold", size: size)
    }
    
    class func semiBoldItalic(size: CGFloat) -> UIFont {
        getFont(name: "Poppins-SemiBoldItalic", size: size)
    }
    
    private class func getFont(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        }
        
        return UIFont.systemFont(ofSize: size)
    }
}
