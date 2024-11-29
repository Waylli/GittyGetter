//
//  LocalDatabase.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine

protocol LocalDatabase: Database {

    func storeOrUpdate(organizations: Organizations) -> AnyPublisher<Success, CustomError>
    func storeOrUpdate(repositories: Repositories,
               parentOrganization organization: Organization) -> AnyPublisher<Success, CustomError>

    func delete(organization: Organization) -> AnyPublisher<Success, CustomError>
    func delete(repository: Repository) -> AnyPublisher<Success, CustomError>

    func updateFavoriteStatus(for repository: Repository, to isFavorite: Bool) -> AnyPublisher<Success, CustomError>

    func initialize() -> AnyPublisher<Success, CustomError>
    func deleteAllData() -> AnyPublisher<Success, CustomError>

}

#if DEBUG
class MockLocalDatabase: LocalDatabase {

    func storeOrUpdate(organizations: Organizations) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func storeOrUpdate(repositories: Repositories, parentOrganization organization: Organization) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func delete(organization: Organization) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func delete(repository: Repository) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func initialize() -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        Just(Organization.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(query: String, within: Organizations) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
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

    func deleteAllData() -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func updateFavoriteStatus(for repository: Repository,
                              to isFavorite: Bool) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

}
#endif
