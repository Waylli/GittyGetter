//
//  OrganizationsListModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

class OrganizationsListModel: ObservableObject {

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
    }
}

extension OrganizationsListModel {

    struct Input {
        let organizations: Organizations
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {

    }

    func createOrganizationCardModel(for organization: Organization) -> OrganizationCardModel {
        let modelInput = OrganizationCardModel
            .Input(organization: organization,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = OrganizationCardModel
            .Output()
        return OrganizationCardModel(with: modelInput, and: modelOutput)
    }

}
