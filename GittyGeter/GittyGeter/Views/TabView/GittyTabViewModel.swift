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
        let allOrganizations: AnyPublisher<Organizations, Never>
        let getRepositories: (String, Organizations) -> AnyPublisher<Repositories, CustomError>
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {
        let userSelectedRepository: PassthroughSubject<Repository, Never>
        let userSelectedOrganization: PassthroughSubject<Organization, Never>
    }

    func makeRepositoriesViewModel() -> RepositoriesViewModel {
        let modelInput = RepositoriesViewModel
            .Input(allOrganizations: input.allOrganizations,
                   getRepositories: input.getRepositories,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = RepositoriesViewModel
            .Output(userSelectedRepository: output.userSelectedRepository)
        return RepositoriesViewModel(with: modelInput, and: modelOutput)
    }

    func makeOrganizationsViewModel() -> OrganizationsViewModel {
        let modelInput = OrganizationsViewModel
            .Input(oragnizations: input.allOrganizations,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = OrganizationsViewModel
            .Output(userSelectedOrganization: output.userSelectedOrganization)
        return OrganizationsViewModel(with: modelInput, and: modelOutput)
    }
}
