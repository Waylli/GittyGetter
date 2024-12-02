//
//  RepositoriesViewSpec.swift
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

class RepositoriesViewSpec: KIFSpec {

    override class func spec() {
        var view: RepositoriesView!
        var viewModel: RepositoriesViewModel!
        let database = MockDatabase()
        var rootView: UIViewController!
        describe("RepositoriesView") {
            beforeEach {
                viewModel = makeRepositoriesViewModel(with: database)
                view = RepositoriesView(with: viewModel)
                rootView = presentView(view: view).rootView
            }
            afterEach {
                cleanUp(rootView: rootView)
                view = nil
                viewModel = nil
            }
            context("when displayed") {

                it("shows the title") {
                    assertViewExists(withAccessibilityLabel: RepositoriesView.TestingIdentifiers.titleView)
                }

                it("shows the sort button") {
                    assertViewExists(withAccessibilityLabel: RepositoriesView.TestingIdentifiers.sortingView)
                }

                it("shows search component") {
                    assertViewExists(withAccessibilityLabel: RepositoriesView.TestingIdentifiers.searchComponent)
                }

                it("shows repository list") {
                    assertViewExists(withAccessibilityLabel: RepositoriesView.TestingIdentifiers.repositoryListComponent)
                }

                it("shows background view") {
                    assertViewExists(withAccessibilityLabel: RepositoriesView.TestingIdentifiers.backgroundView)
                }

                it("shows card") {
                    assertViewExists(withAccessibilityLabel: "RepositoriesListView.\(viewModel.queriedRepositories.first!.name)")
                }
            }
        }

    }
    static
    func makeRepositoriesViewModel(with database: FullRepositoryService) -> RepositoriesViewModel {
        let modelInput = RepositoriesViewModel
            .Input(getAllOrganizations: database.getOrganizations,
                   getRepositories: database.getRepositories(query:within:sortingOrder:),
                   updateFavoriteStatus: database.updateFavoriteStatus(of:to:),
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard())
        let modelOutput = RepositoriesViewModel
            .Output(userSelectedRepository: PassthroughSubject())
        return RepositoriesViewModel(with: modelInput, and: modelOutput)
    }
}
