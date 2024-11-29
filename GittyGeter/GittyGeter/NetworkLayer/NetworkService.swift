//
//  NetworkService.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Combine

protocol NetworkService {
    func fetchOrganizationWith(login: String) -> AnyPublisher<Organization, CustomError>
    func fetchRepositoriesForOrganizationWith(login: String) -> AnyPublisher<Repositories, CustomError>
}

#if DEBUG
class MockNetworkService: NetworkService {
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
#endif
