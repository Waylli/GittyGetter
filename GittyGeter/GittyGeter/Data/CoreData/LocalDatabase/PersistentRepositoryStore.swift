//
//  PersistentRepositoryStore.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine

protocol PersistentRepositoryStore {

    func storeOrUpdate(organizations: Organizations) -> AnyPublisher<Success, CustomError>
    func storeOrUpdate(repositories: Repositories,
               parentOrganization organization: Organization) -> AnyPublisher<Success, CustomError>

    func delete(organization: Organization) -> AnyPublisher<Success, CustomError>
    func delete(repository: Repository) -> AnyPublisher<Success, CustomError>

    func initialize() -> AnyPublisher<Success, CustomError>
    func deleteAllData() -> AnyPublisher<Success, CustomError>

}

#if DEBUG && !TESTING
class MockLocalDatabase: PersistentRepositoryStore {

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

    func getRepositories(query: String,
                         within: Organizations,
                         sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getFavouriteRepositories(with sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(for orgnization: Organization, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func deleteAllData() -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func updateFavoriteStatus(of repository: Repository, to newStatus: Bool) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
}
#endif
