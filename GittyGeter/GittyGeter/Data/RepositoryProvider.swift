//
//  RepositoryProvider.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

protocol RepositoryProvider {
    func getOrganizations() -> AnyPublisher<Organizations, CustomError>
    /// if no organization is provided it should fetch all repositories
    func getRepositories(query: String, within organizations: Organizations, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError>
    func getFavouriteRepositories(with sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError>
    func getRepositories(for organization: Organization, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError>
    func updateFavoriteStatus(of repository: Repository, to newStatus: Bool) -> AnyPublisher<Success, CustomError>
}

#if DEBUG
class MockDatabase: FullRepositoryService {

    let organizations: Organizations
    let repositories: Repositories
    var fetchedRepositories: Repositories
    let initialSortingOrder: SortingOrder

    init(organizations: Organizations = Organization.mocks(),
         repositories: Repositories = Repository.mocks(count: 20),
         fetchedRepositories: Repositories = Repository.mocks(),
         sortingOrder: SortingOrder = Configuration.standard().settings.sorting.forFavorites) {
        self.organizations = organizations
        self.repositories = repositories
        self.fetchedRepositories = fetchedRepositories
        self.initialSortingOrder = sortingOrder
    }

    func getRepositories(query: String,
                         within: Organizations,
                         sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        guard query.count == 0, within.count == 0 else {
            return Just(fetchedRepositories)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        return Just(repositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        Just(organizations)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getFavouriteRepositories(with sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        guard sortingOrder == initialSortingOrder else {
            return Just(fetchedRepositories)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        return Just(repositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(for orgnization: Organization, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        guard sortingOrder == initialSortingOrder else {
            return Just(fetchedRepositories)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        return Just(repositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func updateFavoriteStatus(of repository: Repository, to newStatus: Bool) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

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

    func deleteAllData() -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
}
#endif
