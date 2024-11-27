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
    var getAllRepositories: (String, Organizations) -> AnyPublisher<Repositories, CustomError> {get}
    var getRepositories: (Organization) -> AnyPublisher<Repositories, CustomError> {get}
}

#if DEBUG
class MockDatabase: Database {
    var getAllRepositories: (String, Organizations) -> AnyPublisher<Repositories, CustomError> {
        _getAllRepositories
    }


    var allOrganizations: AnyPublisher<Organizations, Never> {
        Just(Organization.mocks())
            .eraseToAnyPublisher()
    }

    private func _getAllRepositories(query: String,
                            in organizations: Organizations) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    var getRepositories: (Organization) -> AnyPublisher<Repositories, CustomError> {
        _getRepositories(for:)
    }

    private func _getRepositories(for organization: Organization) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
}
#endif
