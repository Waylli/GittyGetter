//
//  RepositoriesListViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import Combine

class RepositoriesListViewModel: ObservableObject {

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
    }
}

extension RepositoriesListViewModel {

    struct Input {
        let isScrollable: Bool
        let repositories: Repositories
        let fetcher: Fetcher
        let configuration: Configuration
        let updateFavoriteStatus: (Repository, Bool) -> AnyPublisher<Success, CustomError>
    }

    struct Output {
        let userSelectedRepository: PassthroughSubject<Repository, Never>
    }
}

extension RepositoriesListViewModel {

    func makeRepositoryCardModel(for repo: Repository) -> RepositoryCardModel {
        let modelInput = RepositoryCardModel
            .Input(repository: repo,
                   fetcher: input.fetcher,
                   configuration: input.configuration,
                   updateFavoriteStatus: input.updateFavoriteStatus)
        let modelOutput = RepositoryCardModel
            .Output()
        return RepositoryCardModel(with: modelInput, and: modelOutput)
    }

    func userselected(this repository: Repository) {
        output.userSelectedRepository.send(repository)
    }

}
