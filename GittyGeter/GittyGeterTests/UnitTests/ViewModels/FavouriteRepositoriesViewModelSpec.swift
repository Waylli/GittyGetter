//
//  FavouriteRepositoriesViewModelSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 01/12/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

class FavouriteRepositoriesViewModelSpec: QuickSpec {

    override class func spec() {
        var database: MockDatabase!
        var model: FavouriteRepositoriesViewModel!

        describe("FavouriteRepositoriesViewModel") {
            context("when initialized") {
                beforeEach {
                    database = MockDatabase()
                    model = makeFavoriteRepositoriesViewModel(service: database)
                }
                it("sets the default sorting order from configuration") {
                    expect(model.sortingOrder).to(equal(Configuration.standard().settings.sorting.forFavorites))
                    expect(model.repositories).toEventually(equal(database.repositories))
                    // Test implementation here
                }
                it("can make RepositoriesListViewModel") {
                    let repositoriesListViewModel = model.makeRepositoriesListViewModel()
                    expect(repositoriesListViewModel.input.repositories).to(equal(database.repositories))
                }
            }

            context("when changing sort order") {
                beforeEach {
                    database = MockDatabase()
                    model = makeFavoriteRepositoriesViewModel(service: database)
                }
                it("changes repositories") {
                    expect(model.sortingOrder).to(equal(Configuration.standard().settings.sorting.forFavorites))
                    expect(model.repositories).toEventually(equal(database.repositories))
                    model.sortingOrder = .updatedAt(ascending: true)
                    expect(model.repositories).toEventually(equal(database.fetchedRepositories))
                }
            }
        }

    }

    static func makeFavoriteRepositoriesViewModel(service: FullRepositoryService) -> FavouriteRepositoriesViewModel {
        let modelInput = FavouriteRepositoriesViewModel
            .Input(getFavouriteRepositories: service.getFavouriteRepositories(with:),
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard(),
                   updateFavoriteStatus: service.updateFavoriteStatus(of:to:))
        let modelOuput = FavouriteRepositoriesViewModel
            .Output(userSelectedRepository: PassthroughSubject())
        return FavouriteRepositoriesViewModel(with: modelInput,
                                              and: modelOuput)
    }
}
