//
//  AppManagerModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

struct AppManagerModel {

    let input: Input

    init(with input: Input) {
        self.input = input
    }
}

extension AppManagerModel {

    struct Input {
        let navigationCoordinator: NavigationCoordinator
        let viewModelFactor: ViewModelFactory
    }

    struct Actions {
        let organizationWasSelected = PassthroughSubject<Organization, Never>()
    }

}

extension AppManagerModel {

    var viewModelFactor: ViewModelFactory {
        input.viewModelFactor
    }

    var navigator: Navigator {
        input.navigationCoordinator
    }

}
