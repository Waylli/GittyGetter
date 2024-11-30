//
//  LocalDatabaseTestHelpers.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

struct LocalDatabaseTestHelpers {

//    static
//    func initialize(this database: LocalCoreDataDatabase, cancelBag: inout CancelBag) {
//        database.initialize().sink { _ in } receiveValue: { _ in }.store(in: &cancelBag)
//        expect(database.backgroundContext).toEventuallyNot(beNil())
//    }

    static
    func storeOrUpdate(repositories: Repositories,
                       organization: Organization,
                       in localCoreDataDatabase: LocalCoreDataDatabase,
                       cancelBag: inout CancelBag) {
        expect(localCoreDataDatabase.backgroundContext).toEventuallyNot(beNil())
        var isSaved = false
        localCoreDataDatabase.storeOrUpdate(repositories: repositories, parentOrganization: organization)
            .sink { _ in

            } receiveValue: { isSaved = $0 }
            .store(in: &cancelBag)
        expect(isSaved).toEventually(beTrue())
    }

    static
    func store(orgs: Organizations,
               in database: LocalCoreDataDatabase,
               cancelBag: inout CancelBag) {
        expect(database.backgroundContext).toNot(beNil())
        var isSaved = false
        database.storeOrUpdate(organizations: orgs)
            .sink { _ in } receiveValue: { isSaved = $0 }
            .store(in: &cancelBag)
        expect(isSaved).toEventuallyNot(beNil())
    }

    static
    func delete(repo: Repository,
                in database: LocalCoreDataDatabase,
                cancelBag: inout CancelBag) {
        var isDeleted = false
        database.delete(repository: repo)
            .sink { _ in } receiveValue: { isDeleted = $0 }
            .store(in: &cancelBag)
        expect(isDeleted).toEventually(beTrue())
    }

    static
    func delete(org: Organization,
                in database: LocalCoreDataDatabase,
                cancelBag: inout CancelBag) {
        var isDeleted = false
        database.delete(organization: org)
            .sink { _ in } receiveValue: { isDeleted = $0 }
            .store(in: &cancelBag)
        expect(isDeleted).toEventually(beTrue())
    }

    static
    func deleteAllData(in database: PersistentRepositoryStore, cancelBag: inout CancelBag) {
        var deleted = false
        database.deleteAllData().sink { _ in } receiveValue: { deleted = $0}
            .store(in: &cancelBag)
        expect(deleted).toEventually(beTrue(), timeout: .seconds(3))
    }

    static func performAndWait<T: Decodable>(publisher: AnyPublisher<T, CustomError>,
                                           timeout: Int = 5) -> (T?, CancelBag) {
        var fetchedValue: T?
        var cancelBag = CancelBag()
        waitUntil(timeout: .seconds(timeout)) { done in
            publisher
                .sink { result in
                    switch result {
                    case .finished: break
                    case .failure(let error): fatalError(error.localizedDescription)
                    }
                } receiveValue: {
                    fetchedValue = $0
                    done()
                }
                .store(in: &cancelBag)
        }
        expect(fetchedValue).notTo(beNil())
        return (fetchedValue, cancelBag)
    }

}
