//
//  RepositoryCardModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import Combine

class RepositoryCardModel: ObservableObject {

    @Published var thumbnail: Photo?
    @Published var isFavorite: Bool
    var cancelBag = CancelBag()

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
        isFavorite = input.repository.isFavourite
        bind()
    }

}

extension RepositoryCardModel {

    struct Input {
        let repository: Repository
        let fetcher: Fetcher
        let configuration: Configuration
        let updateFavoriteStatus: (Repository, Bool) -> AnyPublisher<Success, CustomError>
    }

    struct Output {

    }

    /// comment out if favorite status can be set from here
//    func isFavoritePressed() {
//        isFavorite.toggle()
//    }

}

private
extension RepositoryCardModel {

    func bind() {
        fetchThumbnail()

    }

    func fetchThumbnail() {
        guard let thumbnail = input.repository.avatarURL else {
            return
        }
        input.fetcher.fetchPhoto(from: thumbnail)
            .sink { _ in

            } receiveValue: { [weak self] in
                self?.thumbnail = $0
            }
            .store(in: &cancelBag)
    }

    func handle(this error: CustomError) {

    }
}
