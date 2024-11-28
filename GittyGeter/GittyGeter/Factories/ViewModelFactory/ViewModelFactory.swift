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
            .Input(getAllOrganizations: model.input.database.getOrganizations,
                   getRepositories: model.input.database.getRepositories(query:within:),
                   getFavouriteRepositories: model.input.database.getFavouriteRepositories,
                   fetcher: model.input.fetcher,
                   configuration: model.input.configurtion)
        return GittyTabViewModel(with: modelInput, and: modelOutput)
    }

    func makeDetailModel(for repository: Repository,
                         modelOutput: DetailedRepositoryViewModel.Output) -> DetailedRepositoryViewModel {
        let modelInput = DetailedRepositoryViewModel
            .Input(repository: repository,
                   fetcher: model.input.fetcher,
                   configuration: model.input.configurtion)
        return DetailedRepositoryViewModel(with: modelInput, and: modelOutput)

    }

    func makeDetailedOrganizationViewModel(for organization: Organization,
                                           modelOutput: DetailedOrganizationViewModel.Output) -> DetailedOrganizationViewModel {
        let modelInput = DetailedOrganizationViewModel
            .Input(organization: Organization.mock(),
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard(),
                   getRepositories: model.input.database.getRepositories)
        return DetailedOrganizationViewModel(with: modelInput, and: modelOutput)
    }

}
