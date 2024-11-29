//
//  MoyaProvider.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Moya
import CombineMoya
import Combine


class GitHubAPIProvider: NetworkService {
    // Define the Moya provider
    let provider = MoyaProvider<GitHubService>()

    func fetchOrganizationWith(login: String) -> AnyPublisher<Organization, CustomError> {
        provider.requestPublisher(.fetchOrganizationWith(login: login))
            .tryMap { response in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(Organization.self, from: response.data)
            }
            .mapError {CustomError.from(any: $0)}
            .eraseToAnyPublisher()
    }

    func fetchRepositoriesForOrganizationWith(login: String) -> AnyPublisher<[Repository], CustomError> {
        provider.requestPublisher(.fetchRepositoriesForOrganizationWith(login: login))
            .tryMap { response in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode([Repository].self, from: response.data)
            }
            .mapError {CustomError.from(any: $0)}
            .eraseToAnyPublisher()
    }

}

