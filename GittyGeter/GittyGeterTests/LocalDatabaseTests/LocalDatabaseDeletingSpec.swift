//
//  LocalDatabaseDeletingSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Combine
import Quick
import Nimble
import CoreData
@testable import GittyGeter

class LocalDatabaseDeletingSpec: QuickSpec {
    override class func spec() {
        describe("Deleting Data in LocalDatabase") {
            var orgs: Organizations!
            var repos: Repositories!
            let localDatabase: LocalCoreDataDatabase = LocalCoreDataDatabase()
            var cancelBag: CancelBag!
            
            beforeEach {
                cancelBag = CancelBag()
                orgs = Organization.mocks(count: 10)
                repos = Repository.mocks(count: 20)
                LocalDatabaseTestHelpers.initialize(this: localDatabase, cancelBag: &cancelBag)
                LocalDatabaseTestHelpers.deleteAllData(in: localDatabase, cancelBag: &cancelBag)
            }
            afterEach {
                LocalDatabaseTestHelpers.deleteAllData(in: localDatabase, cancelBag: &cancelBag)
                cancelBag = nil
                orgs = nil
                repos = nil
            }

            context("deleting organizations") {
                beforeEach {
                    LocalDatabaseTestHelpers
                        .store(orgs: orgs, in: localDatabase, cancelBag: &cancelBag)
                    var allOrgs = Organizations()
                    waitUntil { done in
                        localDatabase.getOrganizations()
                            .sink { _ in

                            } receiveValue: {
                                allOrgs = $0
                                done()
                            }
                            .store(in: &cancelBag)
                    }
                    expect(allOrgs.count).to(equal(orgs.count))
                }
                it("should delete a single organization successfully") {
                    LocalDatabaseTestHelpers.delete(org: orgs[0],
                                                    in: localDatabase,
                                                    cancelBag: &cancelBag)
                }
                it("should handle errors when deleting an organization") {
                    LocalDatabaseTestHelpers.delete(org: orgs[0], in: localDatabase, cancelBag: &cancelBag)
                    var gottenError: CustomError?
                    waitUntil { done in
                        localDatabase
                            .getOrganizationEntity(with: orgs[0].identifier)
                            .sink { result in
                                switch result {
                                case .finished: break
                                case .failure(let error):
                                    gottenError = error
                                    done()
                                }
                            } receiveValue: { _ in }
                            .store(in: &cancelBag)
                    }
                    expect(gottenError).notTo(beNil())
                }
                it("should not delete a non-existent organization") {
                    var gottenError: CustomError?
                    waitUntil { done in
                        localDatabase
                            .getOrganizationEntity(with: Organization.mock().identifier)
                            .sink { result in
                                switch result {
                                case .finished: break
                                case .failure(let error):
                                    gottenError = error
                                    done()
                                }
                            } receiveValue: { _ in }
                            .store(in: &cancelBag)
                    }
                    expect(gottenError).notTo(beNil())
                }
            }

            context("deleting repositories") {
                beforeEach {
                    LocalDatabaseTestHelpers
                        .storeOrUpdate(repositories: [repos[0], repos[1]], organization: orgs[0], in: localDatabase, cancelBag: &cancelBag)
                    LocalDatabaseTestHelpers
                        .storeOrUpdate(repositories: [repos[2], repos[3], repos[4]], organization: orgs[1], in: localDatabase, cancelBag: &cancelBag)
                }
                it("should delete a single repository successfully") {
                    LocalDatabaseTestHelpers
                        .delete(repo: repos[0], in: localDatabase, cancelBag: &cancelBag)
                }
                it("should delete multiple repositories successfully") {
                    LocalDatabaseTestHelpers
                        .delete(repo: repos[0], in: localDatabase, cancelBag: &cancelBag)
                    LocalDatabaseTestHelpers
                        .delete(repo: repos[1], in: localDatabase, cancelBag: &cancelBag)
                    LocalDatabaseTestHelpers
                        .delete(repo: repos[3], in: localDatabase, cancelBag: &cancelBag)
                }
                it("should handle errors when deleting a repository") {
                    LocalDatabaseTestHelpers
                        .delete(repo: repos[0], in: localDatabase, cancelBag: &cancelBag)
                    var gottenError: CustomError?
                    localDatabase.delete(repository: repos[0])
                        .sink { result in
                            switch result {
                            case .finished: break
                            case .failure(let error): gottenError = error
                            }
                        } receiveValue: { _ in

                        }
                        .store(in: &cancelBag)
                    expect(gottenError).toEventuallyNot(beNil())
                }
                it("should not delete a non-existent repository") {
                    var gottenError: CustomError?
                    localDatabase.delete(repository: Repository.mock())
                        .sink { result in
                            switch result {
                            case .finished: break
                            case .failure(let error): gottenError = error
                            }
                        } receiveValue: { _ in

                        }
                        .store(in: &cancelBag)
                    expect(gottenError).toEventuallyNot(beNil())
                }
            }

            context("edge cases for deleting data") {
                beforeEach {
                    LocalDatabaseTestHelpers
                        .storeOrUpdate(repositories: [repos[0], repos[1]], organization: orgs[0], in: localDatabase, cancelBag: &cancelBag)
                    LocalDatabaseTestHelpers
                        .storeOrUpdate(repositories: [repos[2], repos[3], repos[4]], organization: orgs[1], in: localDatabase, cancelBag: &cancelBag)
                }
                it("should allow re-adding entities after deletion") {
                    LocalDatabaseTestHelpers.delete(repo: repos[0], in: localDatabase, cancelBag: &cancelBag)
                    LocalDatabaseTestHelpers.storeOrUpdate(repositories: [repos[0]], organization: orgs[3], in: localDatabase, cancelBag: &cancelBag)
                }
            }
        }
    }
}
