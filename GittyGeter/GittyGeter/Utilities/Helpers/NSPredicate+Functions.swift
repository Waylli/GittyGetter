//
//  NSPredicate+Functions.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Foundation
import CoreData

extension NSPredicate {
    static
    func buildPredicate(for query: String,
                        within organizations: Organizations) -> NSCompoundPredicate {
        let identifiers = organizations.map { $0.identifier }

        if query.isEmpty {
            if identifiers.isEmpty {
                return NSCompoundPredicate(andPredicateWithSubpredicates: [])
            } else {
                return NSCompoundPredicate(andPredicateWithSubpredicates: [
                    NSPredicate(format: "organization.identifier IN %@", identifiers)
                ])
            }
        } else {
            if identifiers.isEmpty {
                return NSCompoundPredicate(orPredicateWithSubpredicates: [
                    NSPredicate(format: "name CONTAINS[cd] %@", query),
                    NSPredicate(format: "repositoryDescription CONTAINS[cd] %@", query)
                ])
            } else {
                return NSCompoundPredicate(andPredicateWithSubpredicates: [
                    NSPredicate(format: "organization.identifier IN %@", identifiers),
                    NSCompoundPredicate(orPredicateWithSubpredicates: [
                        NSPredicate(format: "name CONTAINS[cd] %@", query),
                        NSPredicate(format: "repositoryDescription CONTAINS[cd] %@", query)
                    ])
                ])
            }
        }
    }
}
