//
//  OrganizationEntity+Extensions.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine
import CoreData

extension OrganizationEntity {
    static
    func saveOrUpdate(with organization: Organization,
                      in context: NSManagedObjectContext) -> AnyPublisher<OrganizationEntity, CustomError> {
        let fetchRequest: NSFetchRequest<OrganizationEntity> = OrganizationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", organization.identifier)
        fetchRequest.fetchLimit = 1
        let future = Future<OrganizationEntity, CustomError> { promise in
            context.performAndWait {
                do {
                    let results = try context.fetch(fetchRequest)
                    let entity: OrganizationEntity
                    if let existingEntity = results.first {
                        guard existingEntity.updatedAt != organization.updatedAt else {
                            promise(.success(existingEntity)) // No changes needed
                            return
                        }
                        entity = existingEntity
                    } else {
                        entity = OrganizationEntity(context: context)
                    }
                    setValuesIn(entity, from: organization)
                    try context.save()
                    promise(.success(entity))
                } catch {
                    promise(.failure(CustomError.localDatabaseError))
                }
            }
        }
        return Deferred {
            future
        }
        .eraseToAnyPublisher()
    }

    func addRepository(_ repository: RepositoryEntity, in context: NSManagedObjectContext) throws {
        context.performAndWait {
            if self.repositories == nil {
                self.repositories = NSSet()
            }
            self.mutableSetValue(forKey: "repositories").add(repository)
        }
    }

    func toOrganization() throws -> Organization {
        guard let identifier = self.identifier, let name = name else {
            throw CustomError.dataMappingFailed
        }
        return Organization(identifier: identifier,
                            createdAt: createdAt,
                            updatedAt: updatedAt,
                            name: name,
                            description: organizationDescription,
                            websiteUrl: websiteUrl,
                            email: email,
                            followers: Int(followersCount),
                            avatarURL: avatarUrl)
    }

}

private
extension OrganizationEntity {

    static
    func setValuesIn(_ organizationEntity: OrganizationEntity, from organization: Organization) {
        organizationEntity.identifier = organization.identifier
        organizationEntity.createdAt = organization.createdAt
        organizationEntity.organizationDescription = organization.description
        organizationEntity.updatedAt = organization.updatedAt
        organizationEntity.avatarUrl = organization.avatarURL
        organizationEntity.email = organization.email
        organizationEntity.followersCount = Int32(organization.followers)
        organizationEntity.name = organization.name
        organizationEntity.websiteUrl = organization.websiteUrl
    }

}
