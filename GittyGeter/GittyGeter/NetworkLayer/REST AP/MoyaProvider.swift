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
    private let memoryCapacity = 10 * 1024 * 1024 // 10 MB
    private let diskCapacity = 50 * 1024 * 1024 // 50 MB
    private let urlCache: URLCache
    private let provider: MoyaProvider<GitHubService>

    init() {
        urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myCache")
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad // Use cache first if available
        configuration.urlCache = urlCache
        let session = Session(configuration: configuration)
        provider = MoyaProvider<GitHubService>(session: session)
    }

    func fetchOrganizationWith(login: String) -> AnyPublisher<Organization, CustomError> {
        if let url = URL(string: "https://api.github.com/orgs/\(login)"),
           let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url)) {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let organization = try decoder.decode(Organization.self, from: cachedResponse.data)
                return Just(organization)
                    .setFailureType(to: CustomError.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: CustomError.from(any: error)).eraseToAnyPublisher()
            }
        }
        return provider.requestPublisher(.fetchOrganizationWith(login: login))
            .tryMap { response in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let organization = try decoder.decode(Organization.self, from: response.data)
                if let strongResponse = response.response,
                   let url = URL(string: "https://api.github.com/orgs/\(login)") {
                    let cachedResponse = CachedURLResponse(response: strongResponse, data: response.data)
                    self.urlCache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                }
                return organization
            }
            .mapError { CustomError.from(any: $0) }
            .eraseToAnyPublisher()
    }

    func fetchRepositoriesForOrganizationWith(login: String) -> AnyPublisher<[Repository], CustomError> {
        if let url = URL(string: "https://api.github.com/orgs/\(login)/repos"),
           let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url)) {
            do {
                /// make a custom decoder!
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let repositories = try decoder.decode([Repository].self, from: cachedResponse.data)
                return Just(repositories)
                    .setFailureType(to: CustomError.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: CustomError.from(any: error)).eraseToAnyPublisher()
            }
        }

        return provider.requestPublisher(.fetchRepositoriesForOrganizationWith(login: login))
            .tryMap { response in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let repositories = try decoder.decode([Repository].self, from: response.data)
                if let strongResponse = response.response, let url = URL(string: "https://api.github.com/orgs/\(login)/repos") {
                    let cachedResponse = CachedURLResponse(response: strongResponse, data: response.data)
                    self.urlCache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                }
                return repositories
            }
            .mapError { CustomError.from(any: $0) }
            .eraseToAnyPublisher()
    }

    func purgeCache() {
        urlCache.removeAllCachedResponses()
    }

}

