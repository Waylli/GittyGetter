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
}

extension FilterOrganizationsComponentModel {

    struct Input {
        let availableOrganizations: Organizations
        let currentFilteredOrganizations: Organizations
    }

    struct Output {
        let removeFilteredOrganization: PassthroughSubject<Organization, Never>
        let removeAllFilteredOrganizations: PassthroughSubject<Void, Never>
        let applyFilterToOrganization: PassthroughSubject<Organization, Never>
    }
}
