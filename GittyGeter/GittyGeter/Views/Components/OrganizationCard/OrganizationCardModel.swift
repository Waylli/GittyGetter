//
//  OrganizationCardModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

class OrganizationCardModel: ObservableObject {

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
    }
}

extension OrganizationCardModel {

    struct Input {
        let organization: Organization
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {

    }
}
