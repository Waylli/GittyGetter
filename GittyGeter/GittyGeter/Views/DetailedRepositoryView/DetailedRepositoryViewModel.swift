//
//  DetailedRepositoryViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

class DetailedRepositoryViewModel: ObservableObject {

    @Published private(set) var isFavouriteRepository: Bool
    @Published var avatar: Photo?
    var cancelBag = CancelBag()

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
        isFavouriteRepository = input.repository.isFavourite
        bind()
    }

    func favoriteIconTapped() {
        input.updateFavoriteStatus(input.repository, !isFavouriteRepository)
            .sink { _ in

            } receiveValue: { [weak self] in
                if $0 {
                    self?.isFavouriteRepository.toggle()
                }
            }
            .store(in: &cancelBag)
    }
}

extension DetailedRepositoryViewModel {
    struct Input {
        let repository: Repository
        let fetcher: Fetcher
        let configuration: Configuration
        let updateFavoriteStatus: (Repository, Bool) -> AnyPublisher<Success, CustomError>
    }

    struct Output {
        let backButtonTapped: PassthroughSubject<Void, Never>
    }

    func backButtonTapped() {
        output.backButtonTapped.send(())
    }
}

private
extension DetailedRepositoryViewModel {
    func bind() {
        guard let path = input.repository.avatarURL else {
            return
        }
        input.fetcher.fetchPhoto(from: path)
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error): self?.handle(this: error)
                }
            } receiveValue: { [weak self] in
                self?.avatar = $0
            }
            .store(in: &cancelBag)
    }

    func handle(this error: CustomError) {

    }
}
