//
//  ApplicationCoordinatorModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

struct ApplicationCoordinatorModel {

    let input: Input
    let actions = Actions()

    init(with input: Input) {
        self.input = input
    }
}

extension ApplicationCoordinatorModel {

    struct Input {
        let navigationCoordinator: NavigationCoordinator
        let viewModelFactor: ViewModelFactory
        let dataManager: DataManager
    }

    struct Actions {
        let userSelectedRepository = PassthroughSubject<Repository, Never>()
        let userSelectedOrganization = PassthroughSubject<Organization, Never>()
        let backButtonTapped = PassthroughSubject<Void, Never>()
    }

}

extension ApplicationCoordinatorModel {

    var viewModelFactor: ViewModelFactory {
        input.viewModelFactor
    }

    var navigator: Navigator {
        input.navigationCoordinator
    }

}
