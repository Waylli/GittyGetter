//
//  LocalCoreDataDatabase+LocalDatabase.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import CoreData
import Combine

extension LocalCoreDataDatabase: PersistentRepositoryStore {

    func storeOrUpdate(organizations: Organizations) -> AnyPublisher<Success, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.persistentRepositoryStoreError).eraseToAnyPublisher()}
        return organizations
            .publisher
            .flatMap { organization -> AnyPublisher<Success, CustomError> in
                OrganizationEntity.saveOrUpdate(with: organization, in: context)
                    .map {_ -> Success in true}
                    .eraseToAnyPublisher()
            }
            .collect()
            .map {!$0.contains(false)}
            .eraseToAnyPublisher()
    }

    func storeOrUpdate(repositories: Repositories,
                       parentOrganization organization: Organization) -> AnyPublisher<Success, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.persistentRepositoryStoreError).eraseToAnyPublisher()}
        guard repositories.count > 0 else {return Fail(error: CustomError.dataMappingFailed).eraseToAnyPublisher()}
        return repositories
            .publisher
            .flatMap { repository -> AnyPublisher<Success, CustomError> in
                RepositoryEntity
                    .saveOrUpdate(repository: repository, parent: organization, context: context)
                    .map {_ -> Success in true}
                    .eraseToAnyPublisher()
            }
            .collect()
            .map {!$0.contains(false)}
            .eraseToAnyPublisher()
    }

    func delete(organization: Organization) -> AnyPublisher<Success, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.persistentRepositoryStoreError).eraseToAnyPublisher()}
        return getOrganizationEntity(with: organization.identifier)
            .flatMap { entity -> AnyPublisher<Success, CustomError> in
                Future<Success, CustomError> { promise in
                    context.performAndWait {
                        do {
                            context.delete(entity)
                            try context.save()
                            promise(.success(true))
                        } catch {
                            promise(.failure(CustomError.from(any: error)))
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func delete(repository: Repository) -> AnyPublisher<Success, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.persistentRepositoryStoreError).eraseToAnyPublisher()}
        return getRepositoryEntity(with: repository.identifier)
            .flatMap { entity -> AnyPublisher<Success, CustomError> in
                Future<Success, CustomError> { promise in
                    do {
                        context.delete(entity)
                        try context.save()
                        promise(.success(true))
                    } catch {
                        promise(.failure(CustomError.from(any: error)))
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func initialize() -> AnyPublisher<Success, CustomError> {
        guard self.persistentContainer == nil else {
            return Just(true)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        guard let modelURL = Bundle.main.url(forResource: dataModelName, withExtension: "momd"),
              let _ = NSManagedObjectModel(contentsOf: modelURL) else {
            return Fail(error: CustomError.persistentRepositoryStoreError)
                .eraseToAnyPublisher()
        }
        return Future<Success, CustomError> { [weak self] promise in
            guard let this = self, !this.dataModelName.isEmpty else {
                promise(.failure(CustomError.persistentRepositoryStoreError))
                return
            }
            let container = NSPersistentContainer(name: this.dataModelName)
            container.loadPersistentStores { (_, error) in
                if let error = error {
                    promise(.failure(CustomError.from(any: error)))
                    return
                }
                this.persistentContainer = container
                let context = container.newBackgroundContext()
                context.automaticallyMergesChangesFromParent = true
                context.shouldDeleteInaccessibleFaults = true
                this.backgroundContext = context
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }

    func deleteAllData() -> AnyPublisher<Success, CustomError> {
        do {
            try _DeleteAllData()
            return Just(true)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: CustomError.from(any: error))
                .eraseToAnyPublisher()
        }
    }

}

private
extension LocalCoreDataDatabase {

    func _DeleteAllData() throws {
        guard let persistentContainer = persistentContainer else {
            throw CustomError.persistentRepositoryStoreError
        }
        let context = persistentContainer.viewContext
        let entities = persistentContainer.managedObjectModel.entities

        for entity in entities {
            guard let entityName = entity.name else { continue }

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            } catch {
                throw CustomError.persistentRepositoryStoreError
            }
        }
    }

}

extension LocalCoreDataDatabase {
    func getOrganizationEntity(with identifier: String) -> AnyPublisher<OrganizationEntity, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.persistentRepositoryStoreError).eraseToAnyPublisher()}
        let future = Future<OrganizationEntity, CustomError> { promise in
            let request = OrganizationEntity.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", identifier)
            request.fetchLimit = 1
            do {
                guard let organization = try? context.fetch(request).first else {
                    promise(.failure(CustomError.objectNotFound))
                    return
                }
                promise(.success(organization))
            }
        }
        return Deferred {
            future
        }
        .eraseToAnyPublisher()
    }

    func getRepositoryEntity(with identifier: String) -> AnyPublisher<RepositoryEntity, CustomError> {
        guard let context = backgroundContext else {
            return Fail(error: CustomError.persistentRepositoryStoreError)
                .eraseToAnyPublisher()
        }
        let future = Future<RepositoryEntity, CustomError> { promise in
            let request = RepositoryEntity.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", identifier)
            request.fetchLimit = 1
            do {
                guard let repository = try context.fetch(request).first else {
                    promise(.failure(CustomError.objectNotFound))
                    return
                }
                promise(.success(repository))
            } catch {
                promise(.failure(CustomError.from(any: error)))
            }
        }
        return Deferred {
            future
        }
        .eraseToAnyPublisher()

    }
}
