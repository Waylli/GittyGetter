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
            let localDatabase = LocalCoreDataDatabase()
            var cancelBag: CancelBag!
            beforeEach {
                cancelBag = CancelBag()
                organization = Organization.mock()
                repos = Repository.mocks(count: 10)
                LocalDatabaseTestHelpers
                    .initialize(this: localDatabase, cancelBag: &cancelBag)
                LocalDatabaseTestHelpers
                    .deleteAllData(in: localDatabase, cancelBag: &cancelBag)
            }
            afterEach {
                LocalDatabaseTestHelpers
                    .deleteAllData(in: localDatabase, cancelBag: &cancelBag)
                cancelBag = nil
                organization = nil
                repos = nil
            }

            context("fetching organizations") {
                beforeEach {
                    LocalDatabaseTestHelpers
                        .storeOrUpdate(repositories: repos, organization: organization, in: localDatabase, cancelBag: &cancelBag)
                }
                it("should fetch all organizations successfully") {
                    var org: Organization?
                    localDatabase
                        .getOrganizations()
                        .sink { _ in  } receiveValue: { org = $0.first }
                        .store(in: &cancelBag)
                    expect(org).toEventuallyNot(beNil(), timeout: .seconds(1))
                    expect(org).to(equal(organization))
                }
            }

            context("fetching repositories by query") {
                beforeEach {
                    LocalDatabaseTestHelpers
                        .storeOrUpdate(repositories: repos,
                                  organization: organization,
                                  in: localDatabase,
                                  cancelBag: &cancelBag)
                }
                it("should fetch repositories successfully for a valid query") {
                    let query = repos.first!.name
                    var localRepos: Repositories?
                    waitUntil { done in
                        localDatabase
                            .getRepositories(query: query, within: [organization])
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(1))
                }
                it("should fetch repositories for an empty query (all repositories)") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        localDatabase
                            .getRepositories(query: "", within: [])
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(repos.count))
                }
                it("should fetch repositories within specific organizations") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        localDatabase
                            .getRepositories(query: "", within: [organization])
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(beGreaterThan(0))
                }
                it("should fetch repositories without specific organizations") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        localDatabase
                            .getRepositories(query: repos[0].name, within: [])
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(1))
                }
                it("should handle errors when fetching repositories by query") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        localDatabase
                            .getRepositories(query: "", within: [organization])
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
                    LocalDatabaseTestHelpers
                        .storeOrUpdate(repositories: repos,
                                       organization: organization,
                                       in: localDatabase, cancelBag: &cancelBag)
                }
                it("should fetch favourite repositories successfully") {
                    var localRepos: Repositories?
                    waitUntil { done in
                        localDatabase
                            .getFavouriteRepositories()
                            .sink { _ in } receiveValue: { localRepos = $0; done()}
                            .store(in: &cancelBag)
                    }
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(repos.count))
                }
            }

            context("fetching repositories for a specific organization") {
                beforeEach {
                    LocalDatabaseTestHelpers
                        .storeOrUpdate(repositories: repos,
                                       organization: organization,
                                       in: localDatabase, cancelBag: &cancelBag)
                }
                it("should fetch repositories for a given organization successfully") {
                    var localRepos: Repositories?
                    localDatabase.getRepositories(for: organization)
                        .sink { _ in } receiveValue: { localRepos = $0 }.store(in: &cancelBag)
                    expect(localRepos).toEventuallyNot(beNil())
                    expect(localRepos?.count).to(equal(repos.count))
                }
            }
        }

    }

}
