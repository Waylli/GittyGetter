//
//  AppDataManagerDatabaseSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

class AppDataManagerDatabaseSpec: QuickSpec {
    override class func spec() {
        describe("AppDataManager-Database") {
            var dataManager: AppDataManager!
            let localDatabase = LocalCoreDataDatabase()
            let service = MockNetworkService()
            var cancelBag: CancelBag!
            let identifier = AppDataManager.hardcodedOrganizationLogins.randomElement()!
            beforeEach {
                cancelBag = CancelBag()
                _ = LocalDatabaseTestHelpers.performAndWait(publisher: localDatabase.initialize())
                let model = AppDataManagerModel(with: AppDataManagerModel.Input(localDatabase: localDatabase,
                                                                                networkService: service))
                dataManager = AppDataManager(with: model)
                LocalDatabaseTestHelpers
                    .deleteAllData(in: localDatabase, cancelBag: &cancelBag)
            }

            afterEach {
                LocalDatabaseTestHelpers
                    .deleteAllData(in: localDatabase, cancelBag: &cancelBag)
                dataManager = nil
                cancelBag = nil
            }

            context("when getOrganizations is called") {
                beforeEach {
                    let success = LocalDatabaseTestHelpers.performAndWait(publisher: dataManager.addOrganizationWith(identifier))
                    expect(success).notTo(beNil())
                }
                it("should return a list of organizations successfully") {
                    let orgs = LocalDatabaseTestHelpers.performAndWait(publisher: localDatabase.getOrganizations()).0
                    expect(orgs).notTo(beNil())
                    expect(orgs?.count).to(beGreaterThan(0))
                }
            }

            context("when getRepositories is called with a query and organizations") {
                beforeEach {
                    let success = LocalDatabaseTestHelpers.performAndWait(publisher: dataManager.addOrganizationWith(identifier))
                    expect(success).notTo(beNil())
                }
                it("should return a list of repositories successfully") {
                    let repos = LocalDatabaseTestHelpers
                        .performAndWait(publisher: localDatabase.getRepositories(query: "", within: [], sortingOrder: .standard)).0
                    expect(repos).notTo(beNil())
                    expect(repos?.count).to(beGreaterThan(0))
                }
            }

            // MARK: - getFavouriteRepositories
            context("when getFavouriteRepositories is called") {
                beforeEach {
                    let success = LocalDatabaseTestHelpers.performAndWait(publisher: dataManager.addOrganizationWith(identifier))
                    expect(success).notTo(beNil())
                    let repos = LocalDatabaseTestHelpers
                        .performAndWait(publisher: localDatabase.getRepositories(query: "", within: [], sortingOrder: .standard)).0
                    repos!.forEach { repo in
                        _ = LocalDatabaseTestHelpers
                            .performAndWait(publisher: localDatabase.updateFavoriteStatus(of: repo, to: true))
                    }

                }
                it("should return a list of favourite repositories successfully") {
                    let repos = LocalDatabaseTestHelpers
                        .performAndWait(publisher: localDatabase.getFavouriteRepositories(with: .standard)).0
                    expect(repos).notTo(beNil())
                    expect(repos?.count).to(beGreaterThan(0))
                }
            }
            context("when getRepositories is called for a specific organization") {
                beforeEach {
                    let success = LocalDatabaseTestHelpers.performAndWait(publisher: dataManager.addOrganizationWith(identifier))
                    expect(success).notTo(beNil())
                }
                it("should return a list of repositories for the organization successfully") {
                    let repos = LocalDatabaseTestHelpers
                        .performAndWait(publisher: localDatabase.getRepositories(for: service.organization,
                                                                               sortingOrder: SortingOrder.standard)).0
                    expect(repos).notTo(beNil())
                    expect(repos?.count).to(beGreaterThan(0))
                }
            }
        }
    }
}
