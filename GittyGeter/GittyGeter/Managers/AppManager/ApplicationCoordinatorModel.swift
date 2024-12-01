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
    let events: Events

    init(input: Input) {
        self.input = input
        self.events = Events()
    }
}

extension ApplicationCoordinatorModel {

    struct Input {
        let navigationCoordinator: NavigationCoordinator
        let viewModelFactory: ViewModelFactory
        let dataManager: DataManager
    }

    struct Events {
        let repositorySelected = PassthroughSubject<Repository, Never>()
        let organizationSelected = PassthroughSubject<Organization, Never>()
        let backTapped = PassthroughSubject<Void, Never>()
    }
}

// MARK: - Computed Properties

extension ApplicationCoordinatorModel {

    var viewModelFactory: ViewModelFactory {
        input.viewModelFactory
    }

    var navigator: Navigator {
        input.navigationCoordinator
    }
}
