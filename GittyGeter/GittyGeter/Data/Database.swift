//
//  Database.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

protocol Database {
    func getOrganizations() -> AnyPublisher<Organizations, CustomError>
    func getRepositories(qury: String, for: Organizations) -> AnyPublisher<Repositories, CustomError>
    func getFavouriteRepositories() -> AnyPublisher<Repositories, CustomError>
    func getRepositories(for orgnization: Organization) -> AnyPublisher<Repositories, CustomError>
}

#if DEBUG
class MockDatabase: Database {

    func getRepositories(qury: String, for: Organizations) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        Just(Organization.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getFavouriteRepositories() -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(for orgnization: Organization) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

}
#endif
