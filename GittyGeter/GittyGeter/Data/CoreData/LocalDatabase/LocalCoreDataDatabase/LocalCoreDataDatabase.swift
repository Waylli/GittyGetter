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
    var favoriteRepositoriesObserver: CoreDataEntityObserver<RepositoryEntity>?
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
        let predicate = NSPredicate(format: "isFavourite == true")
        let observer: CoreDataEntityObserver<RepositoryEntity> = CoreDataEntityObserver(context: context,
                                                                                        predicate: predicate,
                                                                                        sortingOrder: .standard)
        favoriteRepositoriesCancelable = observer.$observedEntities
            .sink(receiveValue: { [weak self] in
                self?.favoriteRepositories = $0
            })
        favoriteRepositoriesObserver = observer
    }

    func changeSortingOrderOfFavorites(to sortOrder: SortingOrder) {
        let predicate = NSPredicate(format: "isFavourite == true")
        favoriteRepositoriesObserver?.change(predicate: predicate, sortingOrder: sortOrder)
    }


}

private
extension LocalCoreDataDatabase {

}
