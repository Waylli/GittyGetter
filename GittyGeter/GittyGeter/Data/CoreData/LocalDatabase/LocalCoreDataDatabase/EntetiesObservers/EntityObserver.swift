//
//  CoreDataEntityObserver.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Foundation
import CoreData
import Combine

class CoreDataEntityObserver<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {

    typealias EntityType = T

    private lazy var entityFetchedResultsController: NSFetchedResultsController<T> = {
        configureFetchedResultsController(with: context, predicate: initialPredicate, sortingOrder: initialSortOrder)
    }()

    var context: NSManagedObjectContext
    let initialPredicate: NSPredicate
    let initialSortOrder: SortingOrder?
    @Published var observedEntities = [T]()

    init(context: NSManagedObjectContext, predicate: NSPredicate, sortingOrder: SortingOrder?) {
        self.context = context
        self.initialPredicate = predicate
        self.initialSortOrder = sortingOrder
        super.init()
        fetchObjects(for: entityFetchedResultsController)
    }

    func change(predicate: NSPredicate, sortingOrder: SortingOrder?) {
        entityFetchedResultsController = configureFetchedResultsController(with: context, predicate: predicate, sortingOrder: sortingOrder)
        fetchObjects(for: entityFetchedResultsController)  // Re-fetch to update with the new order
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard controller === entityFetchedResultsController else {
            return
        }
        fetchObjects(for: entityFetchedResultsController)
    }

}

private
extension CoreDataEntityObserver {

    func fetchObjects(for frc: NSFetchedResultsController<EntityType>) {
        frc.managedObjectContext.performAndWait {
            do {
                try frc.performFetch()
                observedEntities = frc.fetchedObjects ?? []
            } catch {
                assertionFailure("Failed to fetch objects: \(error)")
            }
        }
    }

    func configureFetchedResultsController(with context: NSManagedObjectContext,
                                           predicate: NSPredicate,
                                           sortingOrder: SortingOrder?) -> NSFetchedResultsController<EntityType> {
        let request = NSFetchRequest<EntityType>(entityName: String(describing: EntityType.self))
        request.predicate = predicate
        if let order = sortingOrder {
            request.sortDescriptors = [order.toNSSortDescriptor()]
        }
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }
}
