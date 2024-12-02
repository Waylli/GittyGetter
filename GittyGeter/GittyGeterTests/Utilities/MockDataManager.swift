//
//  MockDataManager.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 02/12/2024.
//

import Foundation
import Combine

@testable import GittyGeter

class MockDataManager: DataManager {
    func refreshContent() -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func updateFavoriteStatus(of repository: Repository,
                              to isFavorite: Bool) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func addOrganizationWith(_ identifier: String) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func remove(this organization: Organization) -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        Just(Organization.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(query: String, within: Organizations, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getFavouriteRepositories(with sortOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(for orgnization: Organization, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        Just(Repository.mocks())
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

}
