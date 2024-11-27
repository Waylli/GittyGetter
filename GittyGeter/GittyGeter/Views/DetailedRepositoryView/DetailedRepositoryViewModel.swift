//
//  DetailedRepositoryViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation

class DetailedRepositoryViewModel: ObservableObject {

    @Published var isFavoriteRepository: Bool
    @Published var avatar: Photo?
    var cancelBag = CancelBag()

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
        isFavoriteRepository = input.repository.isFavorite
        bind()
    }

}

extension DetailedRepositoryViewModel {
    struct Input {
        let repository: Repository
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {

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

    private func handle(this error: CustomError) {

    }
}
