//
//  FavouriteRepositoriesViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine

class FavouriteRepositoriesViewModel: ObservableObject {

    @Published private(set) var repositories = Repositories()
    @Published var sortingOrder: SortingOrder
    private var fetch: AnyCancellable?
    private var cancelBag = CancelBag()

    let input: Input
    let output: Output

    init(with input: Input, and output: Output) {
        self.input = input
        self.output = output
        sortingOrder = input.configuration.settings.sorting.forFavorites
        bind()
    }

    deinit {
        fetch?.cancel()
        fetch = nil
    }
}

extension FavouriteRepositoriesViewModel {

    struct Input {
        let getFavouriteRepositories: (SortingOrder) -> AnyPublisher<Repositories, CustomError>
        let fetcher: Fetcher
        let configuration: Configuration
        let updateFavoriteStatus: (Repository, Bool) -> AnyPublisher<Success, CustomError>
    }

    struct Output {
        let userSelectedRepository: PassthroughSubject<Repository, Never>
    }
}

extension FavouriteRepositoriesViewModel {
    func makeRepositoriesListViewModel() -> RepositoriesListViewModel {
        let modelInput = RepositoriesListViewModel
            .Input(isScrollable: true,
                   repositories: repositories,
                   fetcher: input.fetcher,
                   configuration: input.configuration,
                   updateFavoriteStatus: input.updateFavoriteStatus)
        let modelOutput = RepositoriesListViewModel
            .Output(userSelectedRepository: output.userSelectedRepository)
        return RepositoriesListViewModel(with: modelInput, and: modelOutput)
    }
}

private
extension FavouriteRepositoriesViewModel {

    func bind() {
        $sortingOrder
            .sink { [weak self] sortingOrder in
                self?.fetchFavorites(with: sortingOrder)
            }
            .store(in: &cancelBag)
    }

    func fetchFavorites(with order: SortingOrder) {
        fetch?.cancel()
        fetch = input.getFavouriteRepositories(order)
            .sink { _ in
                print("handle error if any")
            } receiveValue: { [weak self] in
                self?.repositories = $0
            }
    }

}
