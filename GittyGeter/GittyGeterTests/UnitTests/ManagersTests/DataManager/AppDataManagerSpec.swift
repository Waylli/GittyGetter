//
//  AppDataManagerSpec.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter


class AppDataManagerSpec: QuickSpec {
    override class func spec() {
        var dataManager: AppDataManager!
        let persistentRepositoryStore = LocalCoreDataDatabase()
        let service = MockNetworkService()
        var cancelBag: CancelBag!
        describe("AppDataManager") {
            beforeEach {
                cancelBag = CancelBag()
                _ = LocalDatabaseTestHelpers.performAndWait(publisher: persistentRepositoryStore.initialize())
                let model = AppDataManagerModel(with: AppDataManagerModel.Input(persistentRepositoryStore: persistentRepositoryStore,
                                                                                repositoryProvider: persistentRepositoryStore,
                                                                                networkService: service))
                dataManager = AppDataManager(with: model)
                LocalDatabaseTestHelpers
                    .deleteAllData(in: persistentRepositoryStore, cancelBag: &cancelBag)
            }

            afterEach {
                LocalDatabaseTestHelpers
                    .deleteAllData(in: persistentRepositoryStore, cancelBag: &cancelBag)
                dataManager = nil
                cancelBag = nil
            }
            context("when refreshContent is called") {
                it("should return success if the content is refreshed successfully") {
                    let isRefreshed = LocalDatabaseTestHelpers
                        .performAndWait(publisher: dataManager.refreshContent().eraseToAnyPublisher()).0
                    expect(isRefreshed).notTo(beNil())
                    expect(isRefreshed).to(beTrue())
                }
            }
            context("when add(this: organization) is called") {
                it("should return success if the organization is added successfully") {
                    let isSaved = LocalDatabaseTestHelpers
                        .performAndWait(publisher: dataManager.addOrganizationWith(service.organization.identifier)).0
                    expect(isSaved).notTo(beNil())
                    expect(isSaved).to(beTrue())
                }

            }
            context("when remove(this: organization) is called") {
                it("should return success if the organization is removed successfully") {
                    let isRemoved = LocalDatabaseTestHelpers
                        .performAndWait(publisher: dataManager.addOrganizationWith(service.organization.identifier)).0
                    expect(isRemoved).notTo(beNil())
                    expect(isRemoved).to(beTrue())
                }

                it("should return a failure if removing the organization fails") {
                    // Test that removing an organization returns failure in case of an error
                    var isRemoved: Bool = true
                    waitUntil { done in
                        dataManager.remove(this: Organization.mock())
                            .sink { result in
                                switch result {
                                case .finished: break
                                case .failure:
                                    isRemoved = false
                                    done()
                                }
                            } receiveValue: { _ in

                            }
                            .store(in: &cancelBag)
                    }
                    expect(isRemoved).notTo(beTrue())

                }

                it("should return a failure if trying to remove default organization") {
                    // Test that removing an organization returns failure in case of an error
                    var isRemoved: Bool = true
                    waitUntil { done in
                        dataManager.remove(this: Organization.mock(name: AppDataManager.hardcodedOrganizationLogins.first!))
                            .sink { result in
                                switch result {
                                case .finished: break
                                case .failure:
                                    isRemoved = false
                                    done()
                                }
                            } receiveValue: { _ in

                            }
                            .store(in: &cancelBag)
                    }
                    expect(isRemoved).notTo(beTrue())

                }
            }
        }
    }
}
