//
//  SortingOrder.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Foundation
import CoreData

enum SortingOrder {
    case createdAt(ascending: Bool)
    case updatedAt(ascending: Bool)
    case name(ascending: Bool)
    case organization(ascending: Bool)

}

extension SortingOrder {
    func toNSSortDescriptor() -> NSSortDescriptor {
        switch self {
        case .createdAt(let ascending):
            return NSSortDescriptor(key: "createdAt", ascending: ascending)
        case .updatedAt(let ascending):
            return NSSortDescriptor(key: "updatedAt", ascending: ascending)
        case .name(let ascending):
            return NSSortDescriptor(key: "name", ascending: ascending)
        case .organization(let ascending):
            return NSSortDescriptor(key: "organization", ascending: ascending)
        }
    }

    func next() -> SortingOrder {
        switch self {
        case .createdAt(let ascending):
            ascending ? .createdAt(ascending: false) : .updatedAt(ascending: true)
        case .updatedAt(let ascending):
            ascending ? .updatedAt(ascending: false) : .name(ascending: true)
        case .name(let ascending):
            ascending ? .name(ascending: false) : .organization(ascending: true)
        case .organization(let ascending):
            ascending ? .organization(ascending: false) : .createdAt(ascending: true)
        }
    }

    func readable() -> String {
        switch self {
        case .createdAt(let ascending):
            ascending ? NSLocalizedString("created ASC", comment: "") : NSLocalizedString("created DESC", comment: "")
        case .updatedAt(let ascending):
            ascending ? NSLocalizedString("updated ASC", comment: "") : NSLocalizedString("updataed DESC", comment: "")
        case .name(let ascending):
            ascending ? NSLocalizedString("name ASC", comment: "") : NSLocalizedString("name DESC", comment: "")
        case .organization(let ascending):
            ascending ? NSLocalizedString("organization ASC", comment: "") : NSLocalizedString("organization DESC", comment: "")
        }
    }
}

extension SortingOrder {
    static
    var standard: SortingOrder {
        .name(ascending: true)
    }
}
