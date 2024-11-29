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
            var localDatabase: LocalCoreDataDatabase!
            var cancelBag: CancelBag!
            beforeEach {
                localDatabase = LocalCoreDataDatabase()
                cancelBag = CancelBag()
            }
            afterEach {
                try! localDatabase.forceDeleteAllData()
                cancelBag = nil
                localDatabase = nil
            }
            it("initializes NSPersistentContainer successfully") {
                localDatabase.initialize()
                    .sink { _ in } receiveValue: { _ in }
                    .store(in: &cancelBag)
                expect(localDatabase.persistentContainer).toEventuallyNot(beNil(), timeout: .seconds(1))
                expect(localDatabase.backgroundContext).toEventuallyNot(beNil(), timeout: .seconds(1))
            }

            context("when working with Entities") {
                beforeEach {
                    LocalDatabaseTestHelpers
                        .initialize(this: localDatabase, cancelBag: &cancelBag)
                }
                context("Organization Entity") {
                    it("saves an organization successfully") {
                        let organization = Organization.mock()
                        var isSaved = false
                        waitUntil { done in
                            localDatabase
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
                            localDatabase
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
