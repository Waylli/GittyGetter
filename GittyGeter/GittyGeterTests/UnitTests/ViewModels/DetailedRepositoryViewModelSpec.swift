//
//  DetailedRepositoryViewModelSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 01/12/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

class DetailedRepositoryViewModelSpec: QuickSpec {
    override class func spec() {
        var viewModel: DetailedRepositoryViewModel!
        var mockRepository: Repository!
        var backButtonSubject: PassthroughSubject<Void, Never>!
        var backButtonTriggered: Bool!
        var statusChangeRequested: Bool!
        var cancelBag: CancelBag!

        beforeEach {
            initializeTestState()
        }

        afterEach {
            resetTestState()
        }

        describe("DetailedRepositoryViewModel") {

            context("on initialization") {
                it("fetches avatar") {
                    expect(viewModel.avatar).toEventuallyNot(beNil())
                }
            }

            context("user interactions") {
                it("can ask for status change") {
                    viewModel.favoriteIconTapped()
                    expect(statusChangeRequested).toEventually(beTrue())
                }

                it("can notify that back was pressed") {
                    viewModel.backButtonTapped()
                    expect(backButtonTriggered).toEventually(beTrue())
                }
            }
        }

        func initializeTestState() {
            backButtonTriggered = false
            statusChangeRequested = false
            cancelBag = CancelBag()
            backButtonSubject = PassthroughSubject<Void, Never>()
            backButtonSubject
                .sink { _ in backButtonTriggered = true }
                .store(in: &cancelBag)
            mockRepository = Repository.mock()
            initializeViewModel()
        }

        func resetTestState() {
            viewModel = nil
            mockRepository = nil
            cancelBag = nil
            backButtonSubject = nil
            backButtonTriggered = false
            statusChangeRequested = false
        }

        func initializeViewModel() {
            let updateFavoriteStatus: (Repository, Bool) -> AnyPublisher<Success, CustomError> = { _, _ in
                statusChangeRequested = true
                return Just(true)
                    .setFailureType(to: CustomError.self)
                    .eraseToAnyPublisher()
            }

            let input = DetailedRepositoryViewModel
                .Input(repository: mockRepository,
                       fetcher: MockFetcher(),
                       configuration: Configuration.standard(),
                       updateFavoriteStatus: updateFavoriteStatus)
            let output = DetailedRepositoryViewModel
                .Output(backButtonTapped: backButtonSubject)
            viewModel = DetailedRepositoryViewModel(with: input, and: output)
        }
    }
}
