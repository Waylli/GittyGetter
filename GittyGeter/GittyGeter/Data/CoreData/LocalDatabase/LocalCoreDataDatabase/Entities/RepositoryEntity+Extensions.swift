//
//  RepositoryEntity+Extensions.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine
import CoreData

extension RepositoryEntity {

    static func saveOrUpdate(repository: Repository,
                             parent: Organization,
                             context: NSManagedObjectContext) -> AnyPublisher<RepositoryEntity, CustomError> {
        OrganizationEntity.saveOrUpdate(with: parent, in: context)
            .flatMap { organizationEntity -> AnyPublisher<RepositoryEntity, CustomError> in
                saveOrUpdate(repository: repository, parent: organizationEntity, context: context)
            }
            .eraseToAnyPublisher()
    }

    func toRepository() throws -> Repository {
        guard let identifier = self.identifier,
              let name = name,
              let organization = self.organization?.name else {
            throw CustomError.dataMappingFailed
        }
        return Repository(identifier: identifier,
                          name: name,
                          createdAt: self.createdAt,
                          updatedAt: self.updatedAt,
                          description: self.repositoryDescription,
                          language: self.language,
                          stargazersCount: Int(stargazersCount),
                          forksCount: Int(forksCount),
                          watchers: Int(watchersCount),
                          issues: Int(self.issuesCount),
                          avatarURL: avatarURL,
                          organizationName: organization,
                          isFavourite: self.isFavourite)
    }

}

private
extension RepositoryEntity {
    static
    func saveOrUpdate(repository: Repository,
                      parent: OrganizationEntity,
                      context: NSManagedObjectContext) -> AnyPublisher<RepositoryEntity, CustomError> {
        Future<RepositoryEntity, CustomError> { promise in
            context.perform {
                do {
                    let repoFetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
                    repoFetchRequest.predicate = NSPredicate(format: "identifier == %@", repository.id)
                    let results = try context.fetch(repoFetchRequest)
                    guard results.count <= 1 else {
                        promise(.failure(CustomError.localDatabaseError))
                        return
                    }
                    if let existingEntity = results.first {
                        guard existingEntity.updatedAt != repository.updatedAt else {
                            promise(.success(existingEntity)) // No changes needed
                            return
                        }
                        setValuesIn(existingEntity, from: repository)
                        try context.save()
                        promise(.success(existingEntity))
                    } else {
                        let newEntity = RepositoryEntity(context: context)
                        setValuesIn(newEntity, from: repository)
                        newEntity.organization = parent
                        try context.save()
                        promise(.success(newEntity))
                    }
                } catch {
                    // Handle errors
                    promise(.failure(CustomError.from(any: error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    static
    func setValuesIn(_ repositoryEntity: RepositoryEntity, from repository: Repository) {
        repositoryEntity.identifier = repository.identifier
        repositoryEntity.name = repository.name
        repositoryEntity.createdAt = repository.createdAt
        repositoryEntity.updatedAt = repository.updatedAt
        repositoryEntity.repositoryDescription = repository.description
        repositoryEntity.language = repository.language
        repositoryEntity.stargazersCount = Int32(repository.stargazersCount)
        repositoryEntity.forksCount = Int32(repository.forksCount)
        repositoryEntity.watchersCount = Int32(repository.watchers)
        repositoryEntity.issuesCount = Int32(repository.issues)
        repositoryEntity.avatarURL = repository.avatarURL
        repositoryEntity.isFavourite = repository.isFavourite
    }
}
