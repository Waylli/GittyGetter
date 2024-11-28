//
//  DataManager.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine

protocol DataManager: Database {
    func refreshContent() -> AnyPublisher<Success, CustomError>
    func add(this organization: Organization) -> AnyPublisher<Success, CustomError>
    func remove(this organization: Organization) -> AnyPublisher<Success, CustomError>
}


#if DEBUG
class MockDataManager: DataManager {
    func refreshContent() -> AnyPublisher<Success, CustomError> {
        Just(true)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
    
    func add(this organization: Organization) -> AnyPublisher<Success, CustomError> {
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

}
#endif
