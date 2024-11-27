//
//  Collection+Helpers.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation

extension RangeReplaceableCollection where Element: Equatable {
    mutating func removeSafe(_ element: Element) {
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
        }
    }
}
