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
        let configurration: Configuration
    }

    struct Output {

    }
}

extension RepositoriesListViewModel {

    func createRepositoryCardModel(for repo: Repository) -> RepositoryCardModel {
        let modelInput = RepositoryCardModel
            .Input(repository: repo,
                   fetcher: input.fetcher,
                   configuration: input.configurration)
        let modelOutput = RepositoryCardModel
            .Output()
        return RepositoryCardModel(with: modelInput, and: modelOutput)
    }
    
}
