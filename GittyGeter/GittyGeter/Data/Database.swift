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
    func getFavouriteRepositories() -> AnyPublisher<Repositories, CustomError>
    func getRepositories(for orgnization: Organization) -> AnyPublisher<Repositories, CustomError>
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
            print("111111 returning fetchedRepositories\(getRepositories.count) a query = \(query) a orgs = \(within.count)")
            return Just(fetchedRepositories)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        print("111111 returning getRepositories\(fetchedRepositories.count)")
        return Just(getRepositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        Just(organizations)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getFavouriteRepositories() -> AnyPublisher<Repositories, CustomError> {
        Just(getRepositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(for orgnization: Organization) -> AnyPublisher<Repositories, CustomError> {
        Just(getRepositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

}
#endif
