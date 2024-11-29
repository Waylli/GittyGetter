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
        var cancelBag: CancelBag!

        beforeEach {
            provider = GitHubAPIProvider()
            cancelBag = CancelBag()
        }
        afterEach {
            cancelBag = nil
            provider = nil
        }
        describe("GitHubAPIProvider") {
            context("when fetching organization") {
                it("should return live data") {
                    var organizaton: Organization?
                    waitUntil(timeout: .seconds(5)) { done in
                        provider
                            .fetchOrganizationWith(login: "algorandfoundation")
                            .sink { result in
                                switch result {
                                case .finished: break
                                case .failure(let error): fatalError(error.localizedDescription)
                                }
                            } receiveValue: {
                                organizaton = $0
                                done()
                            }
                            .store(in: &cancelBag)
                    }
                    expect(organizaton).notTo(beNil())
                }
            }

            context("when fetching repositories") {
               it("should retuen live data") {
                    var repositories: Repositories?
                    waitUntil(timeout: .seconds(5)) { done in
                        provider
                            .fetchRepositoriesForOrganizationWith(login: "algorandfoundation")
                            .sink { result in
                                switch result {
                                case .finished: break
                                case .failure(let error): fatalError(error.localizedDescription)
                                }
                            } receiveValue: {
                                repositories = $0
                                done()
                            }
                            .store(in: &cancelBag)
                    }
                    expect(repositories).notTo(beNil())
                }
            }
        }
    }
}
