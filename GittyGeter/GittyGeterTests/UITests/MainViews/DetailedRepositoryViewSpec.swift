//
//  DetailedRepositoryViewSpec.swift
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

class DetailedRepositoryViewSpec: KIFSpec {
    override class func spec() {
        describe("DetailedRepositoryView") {
            var view: DetailedRepositoryView!
            var viewModel: DetailedRepositoryViewModel!
            var mockRepository: Repository!
            var rootViewController: UIViewController!

            beforeEach {
                setUpTestState()
            }

            afterEach {
                tearDownTestState()
            }

            context("when created") {
                it("displays repository statistics views") {
                    assertViewExists(withAccessibilityLabel: "DetailedRepositoryView.\(mockRepository.stargazersCount)")
                    assertViewExists(withAccessibilityLabel: "DetailedRepositoryView.\(mockRepository.forksCount)")
                    assertViewExists(withAccessibilityLabel: "DetailedRepositoryView.\(mockRepository.issues)")
                    assertViewExists(withAccessibilityLabel: "DetailedRepositoryView.\(mockRepository.watchers)")
                }
            }

            func setUpTestState() {
                mockRepository = Repository.mock()
                let modelInput = DetailedRepositoryViewModel
                    .Input(repository: mockRepository,
                           fetcher: MockFetcher(),
                           configuration: Configuration.standard()) { _, _ in
                        Just(true)
                            .setFailureType(to: CustomError.self)
                            .eraseToAnyPublisher()
                    }
                let modelOutput = DetailedRepositoryViewModel
                    .Output(backButtonTapped: PassthroughSubject())
                viewModel = DetailedRepositoryViewModel(with: modelInput, and: modelOutput)
                view = DetailedRepositoryView(with: viewModel)
                rootViewController = presentView(view: view).rootView
            }

            func tearDownTestState() {
                cleanUp(rootView: rootViewController)
                view = nil
                viewModel = nil
            }
        }
    }
}
