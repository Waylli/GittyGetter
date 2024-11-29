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

    static let _dataModelName = "GittyGeter"

    var persistentContainer: NSPersistentContainer?
    var backgroundContext: NSManagedObjectContext?


    init(dataModelName: String =  LocalCoreDataDatabase._dataModelName) {
        self.dataModelName = dataModelName
    }

    func forceDeleteAllData() throws {
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
