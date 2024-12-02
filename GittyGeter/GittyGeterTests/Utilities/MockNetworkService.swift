//
//  MockNetworkService.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 02/12/2024.
//

import Foundation
import Combine

@testable import GittyGeter

class MockNetworkService: RepositoryNetworkService {
    var error: CustomError?
    var organization = Organization.mock()
    var repos = Repository.mocks(count: 30, isFavorite: Bool.random())
    func fetchOrganizationWith(login: String) -> AnyPublisher<Organization, CustomError> {
        guard let error = error else {
            return Just(organization)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: error).eraseToAnyPublisher()
    }

    func fetchRepositoriesForOrganizationWith(login: String) -> AnyPublisher<Repositories, CustomError> {
        guard let error = error else {
            return Just(repos)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: error).eraseToAnyPublisher()
    }

}
