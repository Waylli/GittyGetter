//
//  ViewModelFactory.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

class ViewModelFactory {

    let model: ViewModelFactoryModel

    init(with model: ViewModelFactoryModel) {
        self.model = model
    }
}

extension ViewModelFactory {

    func makeGittyTabViewModel(with modelOutput: GittyTabViewModel.Output) -> GittyTabViewModel {
        let modelInput = GittyTabViewModel
            .Input(allOrganizations: model.input.database.allOrganizations,
                   getRepositories: model.input.database.getAllRepositories(query:for:),
                   fetcher: model.input.fetcher,
                   configuration: model.input.configurtion)
        return GittyTabViewModel(with: modelInput, and: modelOutput)
    }
    
}
