//
//  Collection.swift
//  Photo Recovery
//
//  Created by Umair Afzal on 19/05/2025.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func notEmpty() -> Bool {
        return !isEmpty
    }
}
