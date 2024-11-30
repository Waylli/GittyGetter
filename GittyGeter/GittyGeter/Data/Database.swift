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
    /// if no organization is provided it should fetch all repositories
    func getRepositories(query: String, within organizations: Organizations) -> AnyPublisher<Repositories, CustomError>
    func getFavouriteRepositories(with sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError>
    func getRepositories(for organization: Organization, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError>
    func updateFavoriteStatus(of repository: Repository,to newStatus: Bool) -> AnyPublisher<Success, CustomError>
}

#if DEBUG
class MockDatabase: Database {

    let organizations: Organizations
    let getRepositories: Repositories
    var fetchedRepositories: Repositories

    init(organizations: Organizations = Organization.mocks(),
         getRepositories: Repositories = Repository.mocks(),
         fetchedRepositories: Repositories = Repository.mocks()) {
        self.organizations = organizations
        self.getRepositories = getRepositories
        self.fetchedRepositories = fetchedRepositories
    }

    func getRepositories(query: String, within: Organizations) -> AnyPublisher<Repositories, CustomError> {
        guard query.count == 0, within.count == 0 else {
            return Just(fetchedRepositories)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        return Just(getRepositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        Just(organizations)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getFavouriteRepositories(with sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        Just(getRepositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(for orgnization: Organization, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        Just(getRepositories)
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
