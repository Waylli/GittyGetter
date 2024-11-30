//
//  LocalDatabaseFetchingSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Quick
import Nimble
@testable import GittyGeter

class LocalDatabaseFetchingSpec: QuickSpec {
    override class func spec() {
        describe("Fetching Data from LocalDatabase") {
            var organization: Organization!
            var repos: Repositories!
            let persistentRepositoryStore = LocalCoreDataDatabase()
            var cancelBag: CancelBag!
            beforeEach {
                cancelBag = CancelBag()
                organization = Organization.mock()
                repos = Repository.mocks(count: 10)
                _ = LocalDatabaseTestHelpers.performAndWait(publisher: persistentRepositoryStore.initialize()).0
                _ = LocalDatabaseTestHelpers
                    .performAndWait(publisher: persistentRepositoryStore.deleteAllData()).0
            }
            afterEach {
                _ = LocalDatabaseTestHelpers
                    .performAndWait(publisher: persistentRepositoryStore.deleteAllData()).0
                cancelBag = nil
                organization = nil
                repos = nil
            }

            context("fetching organizations") {
                beforeEach {
                    let isSaved = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.storeOrUpdate(repositories: repos, parentOrganization: organization)).0
                    expect(isSaved).to(beTrue())
                }
                it("should fetch all organizations successfully") {
                    var org: Organization?
                    persistentRepositoryStore
                        .getOrganizations()
                        .sink { _ in  } receiveValue: { org = $0.first }
                        .store(in: &cancelBag)
                    expect(org).toEventuallyNot(beNil(), timeout: .seconds(1))
                    expect(org).to(equal(organization))
                }
            }

            context("fetching repositories by query") {
                beforeEach {
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore.storeOrUpdate(repositories: repos, parentOrganization: organization)).0
                }
                it("should fetch repositories successfully for a valid query") {
                    let query = repos.first!.name
                    var localRepos: Repositories?
                    waitUntil { done in
                        persistentRepositoryStore
                            .getRepositories(query: query, within: [organization], sortingOrder: .standard)
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(1))
                }
                it("should fetch repositories for an empty query (all repositories)") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        persistentRepositoryStore
                            .getRepositories(query: "", within: [], sortingOrder: .standard)
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(repos.count))
                }
                it("should fetch repositories within specific organizations") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        persistentRepositoryStore
                            .getRepositories(query: "", within: [organization], sortingOrder: .standard)
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(beGreaterThan(0))
                }
                it("should fetch repositories without specific organizations") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        persistentRepositoryStore
                            .getRepositories(query: repos[0].name, within: [], sortingOrder: .standard)
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(1))
                }
                it("should handle errors when fetching repositories by query") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        persistentRepositoryStore
                            .getRepositories(query: "", within: [organization], sortingOrder: .standard)
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(repos.count))
                }
            }

            context("fetching favourite repositories") {
                beforeEach {
                    repos = Repository.mocks(count: 10, isFavorite: true)
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore
                            .storeOrUpdate(repositories: repos, parentOrganization: organization))
                }
                it("should fetch favourite repositories successfully") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        persistentRepositoryStore
                            .getFavouriteRepositories(with: .standard)
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(repos.count))
                }
            }

            context("fetching repositories for a specific organization") {
                beforeEach {
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: persistentRepositoryStore
                            .storeOrUpdate(repositories: repos,
                                           parentOrganization: organization))
                }
                it("should fetch repositories for a given organization successfully") {
                    var localRepos: Repositories?
                    persistentRepositoryStore.getRepositories(for: organization, sortingOrder: .standard)
                        .sink { _ in } receiveValue: { localRepos = $0 }.store(in: &cancelBag)
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(repos.count))
                }
            }
        }

    }

}
