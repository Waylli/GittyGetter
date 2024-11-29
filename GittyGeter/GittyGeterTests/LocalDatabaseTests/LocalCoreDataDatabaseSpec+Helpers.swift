//
//  LocalCoreDataDatabaseSpec+Helpers.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine
@testable import GittyGeter

extension LocalCoreDataDatabaseSpec {
    static func populate(this database: LocalDatabase,
                         with organization: Organization,
                         containing repositories: Repositories) -> AnyPublisher<Success, CustomError> {
        database.storeOrUpdate(repositories: repositories, parentOrganization: organization)
    }
}
