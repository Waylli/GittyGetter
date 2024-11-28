//
//  GittyTabViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

class GittyTabViewModel: ObservableObject {

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
    }

}

extension GittyTabViewModel {

    struct Input {
        let getAllOrganizations: () -> AnyPublisher<Organizations, CustomError>
        let getRepositories: (String, Organizations) -> AnyPublisher<Repositories, CustomError>
        let getFavoriteRepositories: () -> AnyPublisher<Repositories, CustomError>
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {
        let userSelectedRepository: PassthroughSubject<Repository, Never>
        let userSelectedOrganization: PassthroughSubject<Organization, Never>
    }

    func makeRepositoriesViewModel() -> RepositoriesViewModel {
        let modelInput = RepositoriesViewModel
            .Input(getAllOrganizations: input.getAllOrganizations,
                   getRepositories: input.getRepositories,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = RepositoriesViewModel
            .Output(userSelectedRepository: output.userSelectedRepository)
        return RepositoriesViewModel(with: modelInput, and: modelOutput)
    }

    func makeOrganizationsViewModel() -> OrganizationsViewModel {
        let modelInput = OrganizationsViewModel
            .Input(getAllOragnizations: input.getAllOrganizations,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = OrganizationsViewModel
            .Output(userSelectedOrganization: output.userSelectedOrganization)
        return OrganizationsViewModel(with: modelInput, and: modelOutput)
    }

    func makeFavoriteRepositoriesViewModel() -> FavoriteRepositoriesViewModel {
        let modelInput = FavoriteRepositoriesViewModel
            .Input(getFavoriteRepositories: input.getFavoriteRepositories,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = FavoriteRepositoriesViewModel
            .Output(userSelectedRepository: output.userSelectedRepository)
        return FavoriteRepositoriesViewModel(with: modelInput, and: modelOutput)
    }
}
