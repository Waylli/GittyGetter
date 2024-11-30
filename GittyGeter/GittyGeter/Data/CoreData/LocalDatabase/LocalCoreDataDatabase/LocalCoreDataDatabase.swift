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

    @Published private(set) var favoriteRepositories = [RepositoryEntity]()
    private
    var favoriteRepositoriesObserver: FavoriteRepositoriesObserver?
    var persistentContainer: NSPersistentContainer?
    var backgroundContext: NSManagedObjectContext? {
        didSet {
            guard favoriteRepositoriesObserver == nil, let context = backgroundContext else {
                return
            }
            makeFavoriteRepositoriesObserver(with: context)
        }
    }
    private var favoriteRepositoriesCancelable: AnyCancellable?


    init(dataModelName: String =  LocalCoreDataDatabase._dataModelName) {
        self.dataModelName = dataModelName
    }

    deinit {
        favoriteRepositoriesCancelable?.cancel()
        favoriteRepositoriesCancelable = nil
    }

    private
    func makeFavoriteRepositoriesObserver(with context: NSManagedObjectContext) {
        let observer = FavoriteRepositoriesObserver(context: context)
        favoriteRepositoriesCancelable = observer.$favoriteRepos
            .sink { [weak self] in
                self?.favoriteRepositories = $0
            }
        favoriteRepositoriesObserver = observer
    }

    func changeSortingOrderOfFavorites(to sortOrder: SortingOrder) {
        guard let favoriteRepositoriesObserver = favoriteRepositoriesObserver else {
            assertionFailure()
            return
        }
        favoriteRepositoriesObserver.change(order: sortOrder)
    }


}

private
extension LocalCoreDataDatabase {

    class FavoriteRepositoriesObserver: NSObject, NSFetchedResultsControllerDelegate {
        private lazy var favoritesFRC: NSFetchedResultsController<RepositoryEntity> = {
            createFetchResoultsControllerFavoriteRepositories(with: context, order: .standard)
        }()
        var context: NSManagedObjectContext
        @Published var favoriteRepos = [RepositoryEntity]()

        init(context: NSManagedObjectContext) {
            self.context = context
            super.init()
            fetchObjects(for: favoritesFRC)
        }

        func change(order: SortingOrder) {
            favoritesFRC = createFetchResoultsControllerFavoriteRepositories(with: context, order: order)
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
            guard controller == favoritesFRC else {
                return
            }
            fetchObjects(for: favoritesFRC)
        }

        private
        func fetchObjects(for frc: NSFetchedResultsController<RepositoryEntity>) {
            frc.managedObjectContext.performAndWait {
                do {
                    try frc.performFetch()
                    favoriteRepos = frc.fetchedObjects ?? []
                } catch {
                    fatalError()
                }
            }
        }

        private
        func createFetchResoultsControllerFavoriteRepositories(with context: NSManagedObjectContext,
                                                               order: SortingOrder) -> NSFetchedResultsController<RepositoryEntity> {
            let request = RepositoryEntity.fetchRequest()
            request.predicate = NSPredicate(format: "isFavourite == true")
            request.sortDescriptors = [order.toNSSortDescriptor()]
            let frc = NSFetchedResultsController(fetchRequest: request,
                                                 managedObjectContext: context,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
            frc.delegate = self
            fetchObjects(for: frc)
            assert(frc.delegate === self, "Delegate is not set correctly")
            return frc
        }

    }
}
