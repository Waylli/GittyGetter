//
//  LocalDatabaseStoringSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Combine
import Quick
import Nimble
@testable import GittyGeter

class LocalDatabaseStoringSpec: QuickSpec {
    override class func spec() {
        describe("Storing and Updating Data in LocalDatabase") {
            var organization: Organization!
            var repos: Repositories!
            let localDatabase = LocalCoreDataDatabase()
            var cancelBag: CancelBag!
            beforeEach {
                cancelBag = CancelBag()
                organization = Organization.mock()
                repos = Repository.mocks(count: 100)
                localDatabase.initialize().sink { _ in } receiveValue: { _ in }.store(in: &cancelBag)
                expect(localDatabase.backgroundContext).toEventuallyNot(beNil())
            }
            afterEach {
                var deleted = false
                localDatabase.deleteAllData().sink { _ in } receiveValue: { deleted = $0}
                    .store(in: &cancelBag)
                expect(deleted).toEventually(beTrue(), timeout: .seconds(3))
                cancelBag = nil
                organization = nil
                repos = nil
            }

            context("storing organizations") {
                it("should store a single organization successfully") {
                    var saved = false
                    waitUntil(timeout: .seconds(10)) { done in
                        localDatabase.storeOrUpdate(organizations: [organization])
                            .sink { _ in

                            } receiveValue: {
                                saved = $0
                                done()
                            }
                            .store(in: &cancelBag)
                    }
                    expect(saved).to(beTrue())
                }
                it("should store multiple organizations successfully") {
                    var saved = false
                    waitUntil(timeout: .seconds(10)) { done in
                        localDatabase.storeOrUpdate(organizations: [organization, Organization.mock(), Organization.mock()])
                            .sink { _ in

                            } receiveValue: {
                                saved = $0
                                done()
                            }
                            .store(in: &cancelBag)
                    }
                    expect(saved).to(beTrue())
                }
                it("should update an existing organization with new data") {
                    var saved = false
                    waitUntil(timeout: .seconds(10)) { done in
                        localDatabase.storeOrUpdate(organizations: [organization])
                            .sink { _ in

                            } receiveValue: {
                                saved = $0
                                done()
                            }
                            .store(in: &cancelBag)
                    }
                    expect(saved).to(beTrue())
                    let updated = Organization(identifier: organization.identifier,
                                               createdAt: organization.createdAt,
                                               updatedAt: Date()+1,
                                               name: "new name",
                                               description: nil,
                                               websiteUrl: organization.websiteUrl,
                                               email: organization.email,
                                               followers: organization.followers,
                                               avatarURL: organization.avatarURL)
                    var isUpdated = false
                    waitUntil(timeout: .seconds(10)) { done in
                        localDatabase.storeOrUpdate(organizations: [updated])
                            .sink { _ in

                            } receiveValue: {
                                isUpdated = $0
                                done()
                            }
                            .store(in: &cancelBag)
                    }
                    expect(isUpdated).to(beTrue())
                }
            }

            context("storing repositories") {
                it("should store a single repository successfully under a parent organization") {
                    var isSaved = false
                    waitUntil(timeout: .seconds(2)) { done in
                        localDatabase.storeOrUpdate(repositories: [repos.first!], parentOrganization: organization)
                            .sink { _ in } receiveValue: { isSaved = $0; done() }
                            .store(in: &cancelBag)
                    }
                    expect(isSaved).to(beTrue())
                }
                it("should store multiple repositories successfully under a parent organization") { var isSaved = false
                    waitUntil(timeout: .seconds(2)) { done in
                        localDatabase.storeOrUpdate(repositories: repos, parentOrganization: organization)
                            .sink { _ in } receiveValue: { isSaved = $0; done() }
                            .store(in: &cancelBag)
                    }
                    expect(isSaved).to(beTrue())
                }
                it("should update an existing repository with new data") {
                    let repo = repos.first!
                    var isSaved = false
                    waitUntil(timeout: .seconds(2)) { done in
                        localDatabase.storeOrUpdate(repositories: [repo], parentOrganization: organization)
                            .sink { _ in } receiveValue: { isSaved = $0; done() }
                            .store(in: &cancelBag)
                    }
                    expect(isSaved).to(beTrue())
                    let updated = Repository(identifier: repo.id,
                                             name: repo.name,
                                             createdAt: repo.createdAt,
                                             updatedAt: Date() + 1,
                                             description: nil,
                                             language: "new",
                                             stargazersCount: 2323123,
                                             forksCount: 221313,
                                             watchers: 211232,
                                             issues: 1,
                                             avatarURL: nil,
                                             organizationName: "no org",
                                             isFavourite: true)
                    var isUpdated = false
                    waitUntil(timeout: .seconds(2)) { done in
                        localDatabase.storeOrUpdate(repositories: [updated], parentOrganization: organization)
                            .sink { _ in } receiveValue: { isUpdated = $0; done() }
                            .store(in: &cancelBag)
                    }
                    expect(isUpdated).to(beTrue())
                }
                it("should handle errors when storing repositories") { }
            }

            context("edge cases for storing data") {
                it("should not create duplicate organizations") { }
                it("should not create duplicate repositories under the same parent organization") { }
                it("should handle storing repositories when the parent organization does not exist") { }
            }
        }
    }
}
