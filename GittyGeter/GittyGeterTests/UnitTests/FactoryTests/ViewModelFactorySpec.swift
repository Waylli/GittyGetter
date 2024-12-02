//
//  ViewModelFactorySpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 01/12/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

class ViewModelFactorySpec: QuickSpec {

    override class func spec() {
        describe("ViewModelFactory") {
            var factory: ViewModelFactory!
            var model: ViewModelFactoryModel!
            var provider: RepositoryProvider!

            beforeEach {
                setUpTestState()
            }

            afterEach {
                tearDownTestState()
            }

            context("creating models") {
                it("creates GittyTabViewModel") {
                    let modelOutput = GittyTabViewModel
                        .Output(userSelectedRepository: PassthroughSubject(),
                                userSelectedOrganization: PassthroughSubject())
                    let gittyTabViewModel = factory
                        .makeGittyTabViewModel(with: modelOutput)
                    expect(gittyTabViewModel).notTo(beNil())
                }

                it("creates DetailedRepositoryViewModel") {
                    let modelOutput = DetailedRepositoryViewModel
                        .Output(backButtonTapped: PassthroughSubject())
                    let detailedRepositoryViewModel = factory
                        .makeDetailedRepositoryViewModel(for: Repository.mock(),
                                                         modelOutput: modelOutput )
                    expect(detailedRepositoryViewModel).notTo(beNil())
                }

                it("creates DetailedOrganizationViewModel") {
                    let modelOutput = DetailedOrganizationViewModel
                        .Output(userSelectedRepository: PassthroughSubject(),
                        backButtonTapped: PassthroughSubject())
                    let detailedOrganizationViewModel = factory.makeDetailedOrganizationViewModel(
                        for: Organization.mock(),
                        modelOutput: modelOutput
                    )
                    expect(detailedOrganizationViewModel).notTo(beNil())
                }
            }
            func setUpTestState() {
                provider = MockDatabase()
                model = createViewModelFactoryModel(provider: provider)
                factory = ViewModelFactory(with: model)
            }

            func tearDownTestState() {
                provider = nil
                model = nil
                factory = nil
            }
        }

        func createViewModelFactoryModel(provider: RepositoryProvider) -> ViewModelFactoryModel {
            let modelInput = ViewModelFactoryModel.Input(
                database: provider,
                fetcher: MockFetcher(),
                configurtion: Configuration.standard()
            )
            return ViewModelFactoryModel(with: modelInput)
        }
    }
}
