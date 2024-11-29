//
//  GitHubServiceSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

class GitHubServiceSpec: QuickSpec {

    override class func spec() {
        var provider: GitHubAPIProvider!
        let orgLogin = AppDataManager.hardcodedOrganizationLogins.randomElement() ?? "algorand"
        beforeEach {
            provider = GitHubAPIProvider()
            provider.purgeCache()
        }
        afterEach {
            provider = nil
        }
        describe("GitHubAPIProvider") {

            context("when fetching organization") {
                it("should return live data from network request") {
                    let organization = LocalDatabaseTestHelpers
                        .performAndWait(publisher: provider.fetchOrganizationWith(login: orgLogin))
                        .0
                    expect(organization).notTo(beNil())
                }
                it("should return cached data from network request") {
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: provider.fetchOrganizationWith(login: orgLogin))
                        .0
                    let organization = LocalDatabaseTestHelpers
                        .performAndWait(publisher: provider.fetchOrganizationWith(login: orgLogin))
                        .0
                    expect(organization).notTo(beNil())
                }
            }

            context("when fetching repositories") {
                it("should return live data from network request") {
                    let repositories = LocalDatabaseTestHelpers
                        .performAndWait(publisher: provider.fetchRepositoriesForOrganizationWith(login: orgLogin))
                        .0
                    expect(repositories).notTo(beNil())
                    expect(repositories?.count).to(beGreaterThan(0))
                }
                it("should return cached data from network request") {
                    _ = LocalDatabaseTestHelpers
                        .performAndWait(publisher: provider.fetchRepositoriesForOrganizationWith(login: orgLogin))
                        .0
                    let repositories = LocalDatabaseTestHelpers
                        .performAndWait(publisher: provider.fetchRepositoriesForOrganizationWith(login: orgLogin))
                        .0
                    expect(repositories).notTo(beNil())
                    expect(repositories?.count).to(beGreaterThan(0))
                }



                context("fetching live data") {
                    beforeEach {
                        provider.purgeCache()
                        let repositories = LocalDatabaseTestHelpers
                            .performAndWait(publisher: provider.fetchRepositoriesForOrganizationWith(login: orgLogin))
                            .0
                        expect(repositories).notTo(beNil())
                    }
                    it("should return cached data") {
                        let repositories = LocalDatabaseTestHelpers
                            .performAndWait(publisher: provider.fetchRepositoriesForOrganizationWith(login: orgLogin))
                            .0
                        expect(repositories).notTo(beNil())
                    }
                }
            }
        }
    }
}
