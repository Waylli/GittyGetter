//
//  OrganizationsViewSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Foundation
import KIF
import Nimble
import Quick
import Combine
@testable import GittyGeter

class OrganizationsViewSpec: KIFSpec {
    override class func spec() {
        var view: OrganizationsView!
        var viewModel: OrganizationsViewModel!
        let database = MockDatabase()
        var rootView: UIViewController!
        describe("OrganizationsView") {
            beforeEach {
                viewModel = makeOrganizationsViewModel(with: database)
                view = OrganizationsView(with: viewModel)
                rootView = presentView(view: view).rootView
            }
            afterEach {
                cleanUp(rootView: rootView)
                view = nil
                viewModel = nil
            }
            context("when displayed") {
                it("shows Add Organization button") {
                    assertViewExists(withAccessibilityLabel: OrganizationsView.TestingIdentifiers.addOrgaButton)
                }
                it("shows the title") {
                    assertViewExists(withAccessibilityLabel: OrganizationsView.TestingIdentifiers.titleView)
                }
            }
        }
    }

    static
    func makeOrganizationsViewModel(with database: FullRepositoryService) -> OrganizationsViewModel {
        let modelInput = OrganizationsViewModel
            .Input(getAllOragnizations: database.getOrganizations,
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard())
        let modelOuptut = OrganizationsViewModel
            .Output(userSelectedOrganization: PassthroughSubject())
        return OrganizationsViewModel(with: modelInput, and: modelOuptut)
    }
}
