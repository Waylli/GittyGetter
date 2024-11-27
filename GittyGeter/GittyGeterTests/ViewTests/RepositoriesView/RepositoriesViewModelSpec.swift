//
//  RepositoriesViewModelSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine
import Quick
import Nimble

@testable import GittyGeter

class RepositoriesViewModelSpec: QuickSpec {

    override class func spec() {
        describe("RepositoriesViewModel") {
            var model: RepositoriesViewModel!
            var organizations: Organizations!
            var repositories: Repositories!
            var actions: RepositoriesViewModel.Actions!
            beforeEach {
                organizations = Organization.mocks()
                repositories = Repository.mocks(count: 20)
                actions = RepositoriesViewModel.Actions()
                model = Self.makeRepositoriesViewModel(organizations: organizations,
                                                         repositories: repositories,
                                                         actions: actions)
            }

            afterEach {
                model = nil
            }

            describe("when query does not throw errors") {
                beforeEach {
                    model = Self.makeRepositoriesViewModel(organizations: organizations,
                                                             repositories: repositories,
                                                             actions: actions)
                }

                context("when initialized") {
                    it("has correct initial state") {
                        expect(model.query).to(equal(""))
                        expect(model.queriedRepositories.count).toEventually(equal(repositories.count), timeout: .seconds(1))
                        expect(model.currentFilteredOrganizations.count).to(equal(0))
                        expect(model.availableOrganizations.count).toEventually(equal(organizations.count), timeout: .seconds(1))
                    }
                }

                context("when creating view models") {
                    it("makes filter organizations component model") {
                        let filterOrganizationsComponentModel = model.makeFilterOrganizationsComponentModel()
                        expect(filterOrganizationsComponentModel).notTo(beNil())
                    }

                    it("makes repositories list view model") {
                        let repositoriesListViewModel = model.makeRepositoriesListViewModel()
                        expect(repositoriesListViewModel).notTo(beNil())
                    }
                }

                context("querying repositorie") {
                    it("returns all repositories for an empty query and no filters") {
                        model.query = ""
                        expect(model.queriedRepositories.count).toEventually(equal(repositories.count), timeout: .seconds(1))
                    }

                    it("returns filtered repositories for a specific query") {
                        model.query = "test"
                        expect(model.queriedRepositories.count).toEventually(equal(Self.queriedRepositoriesCount), timeout: .seconds(1))
                    }
                }

                context("when interacting with actions") {
                    it("filters organizations") {
                        let firstOrg = organizations.first!
                        let secondOrg = organizations[1]
                        actions.applyFilterToOrganization.send(firstOrg)
                        expect(model.queriedRepositories.count).toEventually(equal(Self.queriedRepositoriesCount), timeout: .seconds(1))
                        actions.removeFilteredOrganization.send(firstOrg)
                        expect(model.queriedRepositories.count).toEventually(equal(repositories.count), timeout: .seconds(1))
                        actions.applyFilterToOrganization.send(firstOrg)
                        actions.applyFilterToOrganization.send(secondOrg)
                        expect(model.currentFilteredOrganizations.count).toEventually(equal(2), timeout: .seconds(1))
                        actions.removeAllFilteredOrganizations.send(())
                        expect(model.currentFilteredOrganizations.count).toEventually(equal(0), timeout: .seconds(1))
                    }
                }

                context("when removing a non-existent organization") {
                    it("maintains state when removing a non-existent organization") {
                        actions.applyFilterToOrganization.send(organizations.first!)
                        actions.applyFilterToOrganization.send(organizations.first!)
                        actions.removeFilteredOrganization.send(Organization.mock())
                        expect(model.queriedRepositories.count).toEventually(equal(Self.queriedRepositoriesCount), timeout: .seconds(1))
                    }
                }
            }

            describe("error handling") {
                beforeEach {
                    model = Self.makeErrorThrowingRepositoriesViewModel(organizations: organizations,
                                                                          repositories: repositories,
                                                                          actions: actions)
                }

                it("can handle error") {
                    expect(model.query).to(equal(""))
                    expect(model.currentFilteredOrganizations.count).to(equal(0))
                    expect(model.availableOrganizations.count).toEventually(equal(organizations.count), timeout: .seconds(1))
                    expect(model.queriedRepositories.count).toEventually(equal(0), timeout: .seconds(1))
                }
            }

        }

    }

    private static func makeRepositoriesViewModel(organizations: [Organization],
                                                    repositories: [Repository],
                                                    actions: RepositoriesViewModel.Actions) -> RepositoriesViewModel {
        let modelInput = RepositoriesViewModel.Input(
            allOrganizations: Just(organizations).eraseToAnyPublisher(),
            getRepositories: { query, filtered in
                Self.getRepositories(with: query, filtered: filtered, repositories: repositories)
            },
            fetcher: MockFetcher(),
            configuration: Configuration.standard()
        )
        let modelOutput = RepositoriesViewModel.Output()
        return RepositoriesViewModel(with: modelInput, and: modelOutput, actions: actions)
    }
    private static func getRepositories(with query: String,
                                        filtered: [Organization],
                                        repositories: [Repository]) -> AnyPublisher<[Repository], CustomError> {
        guard query.isEmpty, filtered.isEmpty else {
            return Just(Repository.mocks(count: queriedRepositoriesCount))
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
        return Just(repositories)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    private static func makeErrorThrowingRepositoriesViewModel(organizations: [Organization],
                                                                 repositories: [Repository],
                                                                 actions: RepositoriesViewModel.Actions) -> RepositoriesViewModel {
        let modelInput = RepositoriesViewModel.Input(
            allOrganizations: Just(organizations).eraseToAnyPublisher(),
            getRepositories: { query, filtered in
                Fail(error: CustomError.networkError)
                    .eraseToAnyPublisher()
            },
            fetcher: MockFetcher(),
            configuration: Configuration.standard()
        )
        let modelOutput = RepositoriesViewModel.Output()
        return RepositoriesViewModel(with: modelInput, and: modelOutput, actions: actions)
    }

    private static let queriedRepositoriesCount = 4

}
