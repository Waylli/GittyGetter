//
//  FilterOrganizationsComponentSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 02/12/2024.
//

import Foundation
import KIF
import Nimble
import Quick
import Combine
@testable import GittyGeter

class FilterOrganizationsComponentSpec: KIFSpec {
    override class func spec() {
        describe("FilterOrganizationsComponent") {
            var component: FilterOrganizationsComponent!
            var model: FilterOrganizationsComponentModel!
            var modelOuptut: FilterOrganizationsComponentModel.Output!
            var rootView: UIViewController!
            beforeEach {
                modelOuptut = FilterOrganizationsComponentModel
                    .Output(removeFilteredOrganization: PassthroughSubject(),
                            removeAllFilteredOrganizations: PassthroughSubject(),
                            applyFilterFromOrganization: PassthroughSubject())
            }
            afterEach {
                component = nil
                model = nil
                modelOuptut = nil
                cleanUp(rootView: rootView)
            }
            context("there are available organizations") {
                beforeEach {
                    let input = FilterOrganizationsComponentModel
                        .Input(availableOrganizations: Organization.mocks(),
                               filteredOrganizations: [], configuration: .standard())
                    model = FilterOrganizationsComponentModel(input: input, output: modelOuptut)
                    component = FilterOrganizationsComponent(model: model)
                    rootView = presentView(view: component).rootView

                }
                it("does not show clear all button") {
                    assertViewExists(withAccessibilityLabel: FilterOrganizationsComponent.TestingIdentifiers.mainView)
                }

            }
            context("more than one filtered organization") {
                beforeEach {
                    let input = FilterOrganizationsComponentModel
                        .Input(availableOrganizations: Organization.mocks(),
                               filteredOrganizations: [Organization.mock(), Organization.mock()],
                               configuration: .standard())
                    model = FilterOrganizationsComponentModel(input: input, output: modelOuptut)
                    component = FilterOrganizationsComponent(model: model)
                    rootView = presentView(view: component).rootView

                }
                it("shows clear button") {
                    assertViewExists(withAccessibilityLabel: FilterOrganizationsComponent.TestingIdentifiers.clearFiltersButton)
                }
                it("shows organization chip") {
                    assertViewExists(withAccessibilityLabel: FilterOrganizationsComponent.TestingIdentifiers.clearOrgaButton)
                }
            }
        }
    }
}
