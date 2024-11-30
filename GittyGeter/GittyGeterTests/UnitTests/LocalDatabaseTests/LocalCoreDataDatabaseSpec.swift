//
//  LocalCoreDataDatabaseSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine
import Quick
import Nimble
@testable import GittyGeter

class LocalCoreDataDatabaseSpec: QuickSpec {
    override class func spec() {
        describe("LocalCoreDataDatabase") {
            let persistentRepositoryStore = LocalCoreDataDatabase()
            var cancelBag: CancelBag!
            beforeEach {
                cancelBag = CancelBag()
            }
            afterEach {
                LocalDatabaseTestHelpers.deleteAllData(in: persistentRepositoryStore, cancelBag: &cancelBag)
                cancelBag = nil
            }
            it("initializes NSPersistentContainer successfully") {
                persistentRepositoryStore.initialize()
                    .sink { _ in } receiveValue: { _ in }
                    .store(in: &cancelBag)
                expect(persistentRepositoryStore.persistentContainer).toEventuallyNot(beNil(), timeout: .seconds(1))
                expect(persistentRepositoryStore.backgroundContext).toEventuallyNot(beNil(), timeout: .seconds(1))
            }

            context("when working with Entities") {
                beforeEach {
                    LocalDatabaseTestHelpers
                        .initialize(this: persistentRepositoryStore, cancelBag: &cancelBag)
                }
                context("Organization Entity") {
                    it("saves an organization successfully") {
                        let organization = Organization.mock()
                        var isSaved = false
                        waitUntil { done in
                            persistentRepositoryStore
                                .storeOrUpdate(organizations: [organization])
                                .sink { _ in

                                } receiveValue: {
                                    isSaved = $0
                                    done()
                                }
                                .store(in: &cancelBag)
                        }
                        expect(isSaved).toEventually(beTrue())
                    }
                }
                context("Repository Entity") {
                    it("saves a repository successfully") {
                        let organization = Organization.mock()
                        let repository = Repository.mock()
                        var isSaved = false
                        waitUntil { done in
                            persistentRepositoryStore
                                .storeOrUpdate(repositories: [repository], parentOrganization: organization)
                                .sink { _ in

                                } receiveValue: {
                                    isSaved = $0
                                    done()
                                }
                                .store(in: &cancelBag)
                        }
                        expect(isSaved).toEventually(beTrue(), timeout: .seconds(3))
                    }
                }
            }
        }
    }
}
