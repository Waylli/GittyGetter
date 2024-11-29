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
            var fetchedRepositories: Repositories!
            var actions: RepositoriesViewModel.Actions!
            var database: MockDatabase!
            beforeEach {
                organizations = Organization.mocks()
                repositories = Repository.mocks(count: 20)
                fetchedRepositories = Repository.mocks(count: 4)
                database = MockDatabase(organizations: organizations,
                                        getRepositories: repositories,
                                        fetchedRepositories: fetchedRepositories)
                actions = RepositoriesViewModel.Actions()
                model = Self.makeRepositoriesViewModel(with: database,
                                                       actions: actions)
            }

            afterEach {
                database = nil
                organizations = nil
                repositories = nil
                actions = nil
                model = nil
            }

            describe("when query does not throw errors") {
                beforeEach {
                    model = Self.makeRepositoriesViewModel(with: database,
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
                        expect(model.queriedRepositories.count).toEventually(equal(fetchedRepositories.count),
                                                                             timeout: .seconds(2))
                    }
                }

                context("when interacting with actions") {
                    it("filters organizations") {
                        let firstOrg = organizations.first!
                        let secondOrg = organizations[1]
                        actions.applyFilterToOrganization.send(firstOrg)
                        expect(model.queriedRepositories.count).toEventually(equal(fetchedRepositories.count), timeout: .seconds(1))
                        actions.removeFilteredOrganization.send(firstOrg)
                        expect(model.queriedRepositories.count)
                            .toEventually(equal(repositories.count),
                                          timeout: .seconds(1))
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
                        expect(model.queriedRepositories.count).toEventually(equal(fetchedRepositories.count), timeout: .seconds(1))
                    }
                }
            }

            describe("error handling") {
                beforeEach {
                    model = Self.makeErrorThrowingRepositoriesViewModel(with: database,
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

    private static func makeRepositoriesViewModel(with database: Database,
                                                  actions: RepositoriesViewModel.Actions) -> RepositoriesViewModel {
        let modelInput = RepositoriesViewModel.Input(getAllOrganizations: database.getOrganizations,
                                                     getRepositories: database.getRepositories(query:within:),
                                                     fetcher: MockFetcher(),
                                                     configuration: Configuration.standard())
        let modelOutput = RepositoriesViewModel
            .Output(userSelectedRepository: PassthroughSubject())
        return RepositoriesViewModel(with: modelInput, and: modelOutput, actions: actions)
    }

    private static func makeErrorThrowingRepositoriesViewModel(with database: Database,
                                                               actions: RepositoriesViewModel.Actions) -> RepositoriesViewModel {
        func errorFunction(query: String, orgs: Organizations) -> AnyPublisher<Repositories, CustomError> {
            Fail(error: CustomError.dataMappingFailed)
                .eraseToAnyPublisher()
        }

        let modelInput = RepositoriesViewModel
            .Input(getAllOrganizations: database.getOrganizations,
                   getRepositories: errorFunction(query:orgs:),
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard())
        let modelOutput = RepositoriesViewModel
            .Output(userSelectedRepository: PassthroughSubject())
        return RepositoriesViewModel(with: modelInput, and: modelOutput, actions: actions)
    }

}
