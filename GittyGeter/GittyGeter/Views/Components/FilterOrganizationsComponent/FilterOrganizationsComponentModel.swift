//
//  FilterOrganizationsComponentModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import Combine

class FilterOrganizationsComponentModel {

    let input: Input
    let output: Output

    init(input: Input, output: Output) {
        self.input = input
        self.output = output
    }

    /// Sends an event to remove a specific organization from the filtered list.
    func removeFromFiltered(organization: Organization) {
        output.removeFilteredOrganization.send(organization)
    }

    /// Sends an event to clear all filtered organizations.
    func clearAllFilters() {
        output.removeAllFilteredOrganizations.send(())
    }

    /// Sends an event to apply a filter for a specific organization.
    func applyFilter(for organization: Organization) {
        output.applyFilterFromOrganization.send(organization)
    }
}

extension FilterOrganizationsComponentModel {

    struct Input {
        let availableOrganizations: Organizations
        let filteredOrganizations: Organizations
        let configuration: Configuration
    }

    struct Output {
        let removeFilteredOrganization: PassthroughSubject<Organization, Never>
        let removeAllFilteredOrganizations: PassthroughSubject<Void, Never>
        let applyFilterFromOrganization: PassthroughSubject<Organization, Never>
    }
}
