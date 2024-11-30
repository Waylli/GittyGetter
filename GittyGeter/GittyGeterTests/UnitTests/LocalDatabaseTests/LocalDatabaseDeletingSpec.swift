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
            let persistentRepositoryStore: LocalCoreDataDatabase = LocalCoreDataDatabase()
            var cancelBag: CancelBag!

            beforeEach {
                cancelBag = CancelBag()
                orgs = Organization.mocks(count: 10)
                repos = Repository.mocks(count: 20)
                _ = LocalDatabaseTestHelpers.performAndWait(publisher: persistentRepositoryStore.initialize()).0
                _ = LocalDatabaseTestHelpers
                    .performAndWait(publisher: persistentRepositoryStore.deleteAllData()).0
            }
            afterEach {
                _ = LocalDatabaseTestHelpers
                    .performAndWait(publisher: persistentRepositoryStore.deleteAllData()).0
                cancelBag = nil
                orgs = nil
                repos = nil
            }

            context("deleting organizations") {
                beforeEach {
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.storeOrUpdate(organizations: orgs)).0
                    var allOrgs = Organizations()
                    waitUntil { done in
                        persistentRepositoryStore.getOrganizations()
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
                    let isDeleted = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.delete(organization: orgs[0])).0
                    expect(isDeleted).to(beTrue())
                }
                it("should handle errors when deleting an organization") {
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.delete(organization: orgs[0])).0
                    do {
                        let isDeleted = try LocalDatabaseTestHelpers
                            .throwingPerformAndWait(publisher: persistentRepositoryStore.delete(organization: orgs[0])).0
                        expect(isDeleted).to(beNil())
                    } catch { }
                }
                it("should not delete a non-existent organization") {
                    var gottenError: CustomError?
                    waitUntil { done in
                        persistentRepositoryStore
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
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.storeOrUpdate(repositories: [repos[0], repos[1]], parentOrganization: orgs[0]))
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.storeOrUpdate(repositories: [repos[2], repos[3]], parentOrganization: orgs.first!)).0
                }
                it("should delete a single repository successfully") {
                    let isDeleted = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.delete(repository: repos[0])).0
                    expect(isDeleted).to(beTrue())
                }
                it("should delete multiple repositories successfully") {
                    let isDeleted = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.delete(repository: repos[0])).0
                    expect(isDeleted).to(beTrue())
                    do {
                        _ = try LocalDatabaseTestHelpers
                            .throwingPerformAndWait(publisher: persistentRepositoryStore.delete(repository: repos[0]))
                        _ = try LocalDatabaseTestHelpers
                            .throwingPerformAndWait(publisher: persistentRepositoryStore.delete(repository: repos[0]))
                        _ = try LocalDatabaseTestHelpers
                            .throwingPerformAndWait(publisher: persistentRepositoryStore.delete(repository: repos[0]))
                        fatalError()
                    } catch {
                    }
                }
                it("should handle errors when deleting a repository") {
                    let candidate = repos[0]
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.delete(repository: candidate), timeout: 2).0
                    var gottenError: CustomError?
                    persistentRepositoryStore.delete(repository: repos[0])
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
                    persistentRepositoryStore.delete(repository: Repository.mock())
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
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.storeOrUpdate(repositories: [repos[0], repos[1]], parentOrganization: orgs[0])).0
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.storeOrUpdate(repositories: [repos[2], repos[3], repos[4]], parentOrganization: orgs[1])).0
                }
                it("should allow re-adding entities after deletion") {
                    _ = LocalDatabaseTestHelpers.performAndWait(publisher: persistentRepositoryStore.delete(repository: repos[0])).0
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.storeOrUpdate(repositories: [repos[0], repos[3], repos[4]], parentOrganization: orgs[0])).0
                }
            }
        }
    }
}
