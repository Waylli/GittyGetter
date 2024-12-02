//
//  DetailedOrganizationViewSpec.swift
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

class DetailedOrganizationViewSpec: KIFSpec {

    override class func spec() {
        var view: DetailedOrganizationView!
        var mockOrganization: Organization!
        var viewModel: DetailedOrganizationViewModel!
        var rootViewController: UIViewController!
        var mockDatabase: MockDatabase!

        describe("DetailedOrganizationView") {

            beforeEach {
                setUpTestState()
            }

            afterEach {
                tearDownTestState()
            }

            context("on initialization") {
                it("displays the decoration view") {
                    assertViewExists(withAccessibilityLabel: DetailedOrganizationView.TestingIdentifiers.decorationView)
                }
            }
        }

        func setUpTestState() {
            mockDatabase = MockDatabase()
            mockOrganization = Organization.mock()
            viewModel = createViewModel(for: mockOrganization, using: mockDatabase)
            view = DetailedOrganizationView(with: viewModel)
            rootViewController = presentView(view: view).rootView
        }

        func tearDownTestState() {
            mockDatabase = nil
            mockOrganization = nil
            view = nil
            viewModel = nil
            cleanUp(rootView: rootViewController)
        }

        func createViewModel(for organization: Organization,
                             using service: FullRepositoryService) -> DetailedOrganizationViewModel {
            let input = DetailedOrganizationViewModel.Input(
                organization: organization,
                fetcher: MockFetcher(),
                configuration: Configuration.standard(),
                getRepositories: service.getRepositories(for:sortingOrder:),
                updateFavoriteStatus: service.updateFavoriteStatus(of:to:)
            )

            let output = DetailedOrganizationViewModel.Output(
                userSelectedRepository: PassthroughSubject(),
                backButtonTapped: PassthroughSubject()
            )

            return DetailedOrganizationViewModel(with: input, and: output)
        }
    }
}
