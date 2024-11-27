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

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
    }

    func removeFromFiltered(this organization: Organization) {
        output.removeFilteredOrganization.send(organization)
    }

    func pressedClearAll() {
        output.removeAllFilteredOrganizations.send(())
    }

    func applyFilterFrom(this organization: Organization) {
        output.applyFilterFromOrganization.send(organization)
    }
}

extension FilterOrganizationsComponentModel {

    struct Input {
        let availableOrganizations: Organizations
        let currentFilteredOrganizations: Organizations
        let configuration: Configuration
    }

    struct Output {
        let removeFilteredOrganization: PassthroughSubject<Organization, Never>
        let removeAllFilteredOrganizations: PassthroughSubject<Void, Never>
        let applyFilterFromOrganization: PassthroughSubject<Organization, Never>
    }
}
