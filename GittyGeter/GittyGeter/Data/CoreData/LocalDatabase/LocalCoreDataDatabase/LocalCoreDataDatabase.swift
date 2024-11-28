//
//  LocalCoreDataDatabase.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import CoreData
import Combine

class LocalCoreDataDatabase {

    let dataModelName: String

    private(set) var persistentContainer: NSPersistentContainer?
    private(set) var backgroundContext: NSManagedObjectContext?

    init(dataModelName: String = "LocalDataModel") {
        self.dataModelName = dataModelName
    }

}

extension LocalCoreDataDatabase: LocalDatabase {

    func storeOrUpdate(organizations: Organizations) -> AnyPublisher<Success, CustomError> {
        fatalError()
    }
    
    func storeOrUpdate(repositories: Repositories,
                       parentOrganization organization: Organization) -> AnyPublisher<Success, CustomError> {
        fatalError()
    }
    
    func delete(organizations: Organizations) -> AnyPublisher<Success, CustomError> {
        fatalError()
    }
    
    func delete(repositories: Repositories) -> AnyPublisher<Success, CustomError> {
        fatalError()
    }
    
    func initialize() -> AnyPublisher<Success, CustomError> {
        guard self.persistentContainer == nil else {
            return Just(true)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        let future = Future<Success, CustomError> { [weak self] promise in
            let container = NSPersistentContainer(name: self?.dataModelName ?? "")
            container.loadPersistentStores(completionHandler: { (_, error) in
                guard let error = error else {
                    self?.persistentContainer = container
                    promise(.success(true))
                    return
                }
                promise(.failure(CustomError.from(any: error)))
            })
            let context = container.newBackgroundContext()
            context.automaticallyMergesChangesFromParent = true
            self?.backgroundContext = context
        }
        return Deferred {
            future
        }
        .eraseToAnyPublisher()
    }
    
    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        fatalError()
    }
    
    func getRepositories(query: String, within organizations: Organizations) -> AnyPublisher<Repositories, CustomError> {
        fatalError()
    }
    
    func getFavouriteRepositories() -> AnyPublisher<Repositories, CustomError> {
        fatalError()
    }
    
    func getRepositories(for orgnization: Organization) -> AnyPublisher<Repositories, CustomError> {
        fatalError()
    }

    func deleteAllData() -> AnyPublisher<Success, CustomError> {
        fatalError()
    }

}
