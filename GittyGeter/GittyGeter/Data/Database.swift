//
//  Database.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

protocol Database {
    var allOrganizations: AnyPublisher<Organizations, Never> {get}
    func getAllRepositories(query: String,
                            for organizations: Organizations) -> AnyPublisher<Repositories, CustomError>
}

#if DEBUG
class MockDatabase: Database {

    var allOrganizations: AnyPublisher<Organizations, Never> {
        Just(Organization.mocks())
            .eraseToAnyPublisher()
    }

    func getAllRepositories(query: String, for organizations: Organizations) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
}
#endif
