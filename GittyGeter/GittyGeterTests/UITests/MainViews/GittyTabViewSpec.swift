//
//  GittyTabViewSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 01/12/2024.
//

import Foundation
import KIF
import Nimble
import Quick
import Combine
@testable import GittyGeter

class GittyTabViewSpec: KIFSpec {
    override class func spec() {
        var view: GittyTabView!
        var viewModel: GittyTabViewModel!
        let database = MockDatabase()
        var rootView: UIViewController!
        beforeEach {
            viewModel = makeGittyTabViewModel(database: database)
            view = GittyTabView(with: viewModel)
            rootView = presentView(view: view).rootView
        }
        afterEach {
            cleanUp(rootView: rootView)
            view = nil
            viewModel = nil
        }
        describe("GittyTabView") {
            context("repository tab") {
                beforeEach {
                    tester().waitForAnimationsToFinish()
                    viewModel.selectedTab = .repositories
                    tester().waitForAnimationsToFinish()
                }
                it("shows all views") {
                    assertViewExists(withAccessibilityLabel: GittyTabView.TestingIdentifiers.tabView)
                    assertViewExists(withAccessibilityLabel: GittyTabView.TestingIdentifiers.repositoriesView)
                }
            }
            context("favorites tab") {
                beforeEach {
                    tester().waitForAnimationsToFinish()
                    viewModel.selectedTab = .favorite
                    tester().waitForAnimationsToFinish()
                }
                it("shows all views") {
                    assertViewExists(withAccessibilityLabel: GittyTabView.TestingIdentifiers.tabView)
                    assertViewExists(withAccessibilityLabel: GittyTabView.TestingIdentifiers.favouriteRepositoriesView)
                }
            }
            context("organizations tab") {
                beforeEach {
                    tester().waitForAnimationsToFinish()
                    viewModel.selectedTab = .organizations
                    tester().waitForAnimationsToFinish()
                }
                it("shows all views") {
                    assertViewExists(withAccessibilityLabel: GittyTabView.TestingIdentifiers.tabView)
                    assertViewExists(withAccessibilityLabel: GittyTabView.TestingIdentifiers.organizationsView)
                }
            }
        }
    }

    static
    private func makeGittyTabViewModel(database: FullRepositoryService) -> GittyTabViewModel {
        let modelInput = GittyTabViewModel
            .Input(getAllOrganizations: database.getOrganizations,
                   getRepositories: database.getRepositories(query:within:sortingOrder:),
                   getFavouriteRepositories: database.getFavouriteRepositories(with:),
                   updateFavoriteStatus: database.updateFavoriteStatus(of:to:),
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard())
        let modelOutput = GittyTabViewModel
            .Output(userSelectedRepository: PassthroughSubject(),
                    userSelectedOrganization: PassthroughSubject())
        return GittyTabViewModel(with: modelInput,
                                 and: modelOutput)
    }
}
