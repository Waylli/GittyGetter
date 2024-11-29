//
//  AppDataManagerModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation

class AppDataManagerModel {

    let input: Input

    init(with input: Input) {
        self.input = input
    }
}

extension AppDataManagerModel {
    struct Input {
        let localDatabase: LocalDatabase
        let networkService: NetworkService
    }
}
