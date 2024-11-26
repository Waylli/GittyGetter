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
    var cancelBag = CancelBag()

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
        bind()
    }

}

extension RepositoryCardModel {

    struct Input {
        let repository: Repository
        let fetchImage: (String) -> AnyPublisher<Photo, CustomError>
    }

    struct Output {

    }

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
        input.fetchImage(thumbnail)
            .sink { _ in

            } receiveValue: { [weak self] in
                self?.thumbnail = $0
            }
            .store(in: &cancelBag)
    }

    func handle(this error: CustomError) {

    }
}
