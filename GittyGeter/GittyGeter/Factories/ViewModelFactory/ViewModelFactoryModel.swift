//
//  ViewModelFactoryModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation

struct ViewModelFactoryModel {

    let input: Input

    init(with input: Input) {
        self.input = input
    }
}

extension ViewModelFactoryModel {
    struct Input {
        let database: Database
        let fetcher: Fetcher
        let configurtion: Configuration
    }
}
