//
//  LocalCoreDataDatabase+Database.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Foundation
import Combine

extension LocalCoreDataDatabase: RepositoryProvider {
    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.persistentRepositoryStoreError).eraseToAnyPublisher()}
        let future = Future<Organizations, CustomError> { promise in
            context.performAndWait {
                let request = OrganizationEntity.fetchRequest()
                do {
                    let entities = try context.fetch(request)
                    let orgs = entities.map {try? $0.toOrganization()}.compactMap {$0}
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
                         within organizations: Organizations,
                         sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        guard let context = self.backgroundContext else {return Fail(error: CustomError.persistentRepositoryStoreError).eraseToAnyPublisher()}
        let request = RepositoryEntity.fetchRequest()
        request.predicate = NSPredicate.buildPredicate(for: query, within: organizations)
        request.sortDescriptors = [sortingOrder.toNSSortDescriptor()]
        let future = Future<Repositories, CustomError> { promise in
            context.performAndWait {
                do {
                    let results = try context.fetch(request)
                    let repositories = results.map {try? $0.toRepository()}
                        .compactMap {$0}
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
            .removeDuplicates()
            .map {$0.map {try? $0.toRepository()}.compactMap {$0}}
            .receive(on: RunLoop.main)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    func getRepositories(for organization: Organization, sortingOrder: SortingOrder) -> AnyPublisher<Repositories, CustomError> {
        getRepositories(query: "", within: [organization], sortingOrder: sortingOrder)
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
