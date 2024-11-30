//
//  LocalCoreDataDatabase+LocalDatabase.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import CoreData
import Combine

extension LocalCoreDataDatabase: LocalDatabase {

    func storeOrUpdate(organizations: Organizations) -> AnyPublisher<Success, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.localDatabaseError).eraseToAnyPublisher()}
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
        guard let context = self.backgroundContext else {return Fail(error: CustomError.localDatabaseError).eraseToAnyPublisher()}
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
        guard let context = self.backgroundContext else {return Fail(error: CustomError.localDatabaseError).eraseToAnyPublisher()}
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
        guard let context = self.backgroundContext else {return Fail(error: CustomError.localDatabaseError).eraseToAnyPublisher()}
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
            return Fail(error: CustomError.localDatabaseError)
                .eraseToAnyPublisher()
        }
        return Future<Success, CustomError> { [weak self] promise in
            guard let this = self, !this.dataModelName.isEmpty else {
                promise(.failure(CustomError.localDatabaseError))
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


    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.localDatabaseError).eraseToAnyPublisher()}
        let future = Future<Organizations, CustomError> { promise in
            context.performAndWait {
                let request = OrganizationEntity.fetchRequest()
                do {
                    let entities = try context.fetch(request)
                    let orgs = entities.map {try? $0.toOrganization()}.compactMap{$0}
                    promise(.success(orgs))
                } catch {
                    promise(.failure(CustomError.from(any: error)))
                }
            }
        }
        return Deferred {
            future
        }
        .eraseToAnyPublisher()
    }

    func getRepositories(query: String,
                         within organizations: Organizations) -> AnyPublisher<Repositories, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.localDatabaseError).eraseToAnyPublisher()}
        let request = RepositoryEntity.fetchRequest()
        request.predicate = buildPredicate(for: query, within: organizations)
        let future = Future<Repositories, CustomError> { promise in
            context.performAndWait {
                do {
                    let results = try context.fetch(request)
                    let repositories = results.map {try? $0.toRepository()}
                        .compactMap{$0}
                    promise(.success(repositories))
                } catch {
                    promise(.failure(CustomError.from(any: error)))
                }
            }
        }
        return Deferred {
            future
        }
        .eraseToAnyPublisher()
    }

    func getFavouriteRepositories(with sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        self.changeSortingOrderOfFavorites(to: sortingOrder)
        return $favoriteRepositories
            .map {$0.map {try? $0.toRepository()}.compactMap{$0}}
            .receive(on: RunLoop.main)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(for organization: Organization, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        getRepositories(query: "", within: [organization])
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

    func updateFavoriteStatus(of repository: Repository,
                              to isFavorite: Bool) -> AnyPublisher<Success, CustomError> {
        guard let context = backgroundContext else {
            return Fail(error: CustomError.objectNotFound).eraseToAnyPublisher()
        }
        return getRepositoryEntity(with: repository.identifier)
            .flatMap { entity -> AnyPublisher<Success, CustomError> in
                Future<Success, CustomError> { promise in
                    context.performAndWait {
                        entity.isFavourite = isFavorite
                        do {
                            try context.save()
                            promise(.success(true))
                        } catch {
                            promise(.failure(CustomError.from(any: error)))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

}


private
extension LocalCoreDataDatabase {

    func buildPredicate(for query: String,
                        within organizations: Organizations) -> NSCompoundPredicate {
        let identifiers = organizations.map { $0.identifier }

        if query.isEmpty {
            if identifiers.isEmpty {
                return NSCompoundPredicate(andPredicateWithSubpredicates: [])
            } else {
                return NSCompoundPredicate(andPredicateWithSubpredicates: [
                    NSPredicate(format: "organization.identifier IN %@", identifiers)
                ])
            }
        } else {
            if identifiers.isEmpty {
                return NSCompoundPredicate(orPredicateWithSubpredicates: [
                    NSPredicate(format: "name CONTAINS[cd] %@", query),
                    NSPredicate(format: "repositoryDescription CONTAINS[cd] %@", query)
                ])
            } else {
                return NSCompoundPredicate(andPredicateWithSubpredicates: [
                    NSPredicate(format: "organization.identifier IN %@", identifiers),
                    NSCompoundPredicate(orPredicateWithSubpredicates: [
                        NSPredicate(format: "name CONTAINS[cd] %@", query),
                        NSPredicate(format: "repositoryDescription CONTAINS[cd] %@", query)
                    ])
                ])
            }
        }
    }

    func _DeleteAllData() throws {
        guard let persistentContainer = persistentContainer else {
            throw CustomError.localDatabaseError
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
                throw CustomError.localDatabaseError
            }
        }
    }

}

extension LocalCoreDataDatabase {
    func getOrganizationEntity(with identifier: String) -> AnyPublisher<OrganizationEntity, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.localDatabaseError).eraseToAnyPublisher()}
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
            return Fail(error: CustomError.localDatabaseError)
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
