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
//        var cancelBag: CancelBag!

        describe("FavouriteRepositoriesViewModel") {
//            beforeEach {
//                cancelBag = CancelBag()
//            }
//            afterEach {
//                cancelBag = nil
//            }
            xcontext("when initialized") {
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


//class FavouriteRepositoriesViewModelSpec: QuickSpec {
//    override class func spec() {
//        var viewModel: FavouriteRepositoriesViewModel!
//        var input: FavouriteRepositoriesViewModel.Input!
//        var output: FavouriteRepositoriesViewModel.Output!
//        var mockFetcher: MockFetcher!
//        var mockConfiguration: Configuration!
//        var mockUpdateFavoriteStatus: ((Repository, Bool) -> AnyPublisher<Success, CustomError>)!
//        var mockGetFavouriteRepositories: ((SortingOrder) -> AnyPublisher<Repositories, CustomError>)!
//
//        beforeEach {
//            mockFetcher = MockFetcher()
//            mockConfiguration = Configuration.standard()
//            mockUpdateFavoriteStatus = { _, _ in Just(true).setFailureType(to: CustomError.self).eraseToAnyPublisher() }
//            mockGetFavouriteRepositories = { _ in Just(Repositories()).setFailureType(to: CustomError.self).eraseToAnyPublisher() }
//
//            input = FavouriteRepositoriesViewModel.Input(
//                getFavouriteRepositories: mockGetFavouriteRepositories,
//                fetcher: mockFetcher,
//                configuration: mockConfiguration,
//                updateFavoriteStatus: mockUpdateFavoriteStatus
//            )
//            output = FavouriteRepositoriesViewModel.Output(userSelectedRepository: PassthroughSubject())
//            viewModel = FavouriteRepositoriesViewModel(with: input, and: output)
//        }
//
//        afterEach {
//            viewModel = nil
//        }
//
//        describe("FavouriteRepositoriesViewModel") {
//
//            context("when initialized") {
//                it("sets the sorting order from configuration settings") {
//                    expect(viewModel.sortingOrder.readable())
//                        .to(equal(mockConfiguration.settings.sorting.forFavorites.readable()))
//                }
//
//                it("initializes with an empty repositories list") {
//                    expect(viewModel.repositories.count).to(equal(0))
//                }
//
//                it("sets up input and output properties correctly") {
//                    expect(viewModel.input).toNot(beNil())
//                    expect(viewModel.output).toNot(beNil())
//                }
//            }
//
//            context("when sorting order is updated") {
//                it("fetches favorite repositories") {
//                    var fetchCalled = false
//                    mockGetFavouriteRepositories = { _ in
//                        fetchCalled = true
//                        return Just(Repositories()).setFailureType(to: CustomError.self).eraseToAnyPublisher()
//                    }
//                    viewModel.sortingOrder = .createdAt(ascending: true)
//                    expect(fetchCalled).toEventually(beTrue())
//                }
//
//                it("cancels previous fetch requests") {
//                    let cancellable = viewModel.input.getFavouriteRepositories(.createdAt(ascending: true)).sink(receiveCompletion: { _ in }, receiveValue: { _ in })
//                    expect(cancellable).toNot(beNil())
//                    viewModel.sortingOrder = .name(ascending: true)
//                    // Ensure old fetch is cancelled (check if new fetch is created instead)
//                }
//            }
//
//            context("when fetching repositories") {
//                it("updates the repositories list on success") {
//                    let repositories = Repository.mocks()
//                    mockGetFavouriteRepositories = { _ in
//                        return Just(repositories).setFailureType(to: CustomError.self).eraseToAnyPublisher()
//                    }
//                    viewModel.sortingOrder = .createdAt(ascending: true)
//                    expect(viewModel.repositories).toEventually(equal(repositories))
//                }
//
//                it("handles errors gracefully") {
//                    mockGetFavouriteRepositories = { _ in
//                        return Fail(error: CustomError.networkError).eraseToAnyPublisher()
//                    }
//                    viewModel.sortingOrder = .createdAt(ascending: true)
//                    // Ensure repositories list is not updated
//                    expect(viewModel.repositories.count).toEventually(equal(0))
//                }
//            }
//
//            context("when interacting with child view models") {
//                it("creates a valid RepositoriesListViewModel") {
//                    let listViewModel = viewModel.makeRepositoriesListViewModel()
//                    expect(listViewModel).toNot(beNil())
//                }
//
//                it("passes the correct userSelectedRepository subject") {
//                    let listViewModel = viewModel.makeRepositoriesListViewModel()
//                    expect(listViewModel.output.userSelectedRepository).to(beIdenticalTo(output.userSelectedRepository))
//                }
//            }
//        }
//    }
//}
