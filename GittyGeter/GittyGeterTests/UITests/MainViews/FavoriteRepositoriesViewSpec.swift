//
//  FavoriteRepositoriesViewSpec.swift
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

class FavoriteRepositoriesViewSpec: KIFSpec {
    override class func spec() {
        var view: FavouriteRepositoriesView!
        var viewModel: FavouriteRepositoriesViewModel!
        var database: FullRepositoryService!
        var rootView: UIViewController!
        afterEach {
            cleanUp(rootView: rootView)
            view = nil
            viewModel = nil
        }
        describe("FavouriteRepositoriesView") {

            context("when displaying") {
                beforeEach {
                    database = MockDatabase()
                    viewModel = makeFavouriteRepositoriesViewModel(database: database)
                    view = FavouriteRepositoriesView(with: viewModel)
                    rootView = presentView(view: view).rootView
                }
                it("shows always the placeholder") {
                    assertViewExists(withAccessibilityLabel: FavouriteRepositoriesView.TestingIdentifiers.placeholderView)
                }
            }
            context("when there are favorite repositories") {
                beforeEach {
                    database = MockDatabase()
                    viewModel = makeFavouriteRepositoriesViewModel(database: database)
                    view = FavouriteRepositoriesView(with: viewModel)
                    rootView = presentView(view: view).rootView
                }
                it("shows favorite title") {
                    assertViewExists(withAccessibilityLabel: FavouriteRepositoriesView.TestingIdentifiers.titleView)
                }
                it("shows repository list") {
                    assertViewExists(withAccessibilityLabel: FavouriteRepositoriesView.TestingIdentifiers.repositoriesView)
                }
            }
            context("when there are no favorite repositories") {
                beforeEach {
                    database = MockDatabase(organizations: [],
                                            repositories: [],
                                            fetchedRepositories: [],
                                            favouriteRepositories: [])
                    viewModel = makeFavouriteRepositoriesViewModel(database: database)
                    view = FavouriteRepositoriesView(with: viewModel)
                    rootView = presentView(view: view).rootView
                }
                it("shows no favorite view") {
                    assertViewExists(withAccessibilityLabel: FavouriteRepositoriesView.TestingIdentifiers.noRepositoriesView)
                }
                it("does not show repository list") {
                    assertViewDoesNotExist(withAccessibilityLabel: FavouriteRepositoriesView.TestingIdentifiers.repositoriesView)
                }
            }
        }
    }

    static
    func makeFavouriteRepositoriesViewModel(database: FullRepositoryService) -> FavouriteRepositoriesViewModel {
        let modelInput = FavouriteRepositoriesViewModel
            .Input(getFavouriteRepositories: database.getFavouriteRepositories(with:),
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard(),
                   updateFavoriteStatus: database.updateFavoriteStatus(of:to:))
        let modelOutput = FavouriteRepositoriesViewModel
            .Output(userSelectedRepository: PassthroughSubject())
        return FavouriteRepositoriesViewModel(with: modelInput, and: modelOutput)
    }
}
