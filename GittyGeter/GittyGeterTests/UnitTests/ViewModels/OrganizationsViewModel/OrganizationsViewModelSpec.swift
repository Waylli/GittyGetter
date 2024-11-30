//
//  OrganizationsViewModelSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

class OrganizationsViewModelSpec: QuickSpec {

    override class func spec() {
        describe("OrganizationsViewModel") {
            var model: OrganizationsViewModel!
            var organizations: Organizations!
            var database: RepositoryProvider!
            beforeEach {
                organizations = Organization.mocks()
                database = MockDatabase(organizations: organizations)
                model = createModel(with: database)
            }

            afterEach {
                database = nil
                model = nil
                organizations = nil
            }

            context("when initialized") {
                it("has correct state") {
                    expect(model.organizations.count).toEventually(equal(organizations.count), timeout: .seconds(1))
                }
            }
            context("when creating view models") {
                it("makes organizations list model") {
                    let organizationsListModel = model.makeOrganizationsListModel()
                    expect(organizationsListModel).notTo(beNil())
                }
            }
        }
    }

    static
    private func createModel(with database: RepositoryProvider) -> OrganizationsViewModel {
        let modelInput = OrganizationsViewModel
            .Input(getAllOragnizations: database.getOrganizations,
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard())
        let modelOutput = OrganizationsViewModel
            .Output(userSelectedOrganization: PassthroughSubject())
        return OrganizationsViewModel(with: modelInput, and: modelOutput)
    }

}
