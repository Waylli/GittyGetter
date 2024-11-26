//
//  RepositoryCardModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import Combine

class RepositoryCardModel: ObservableObject {

    @Published var repository: Repository?
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
        let repository: AnyPublisher<Repository, CustomError>
        let fetchImage: (String) -> AnyPublisher<Photo, CustomError>
    }

    struct Output {

    }

}

private
extension RepositoryCardModel {

    func bind() {
        input.repository
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .finished: return
                case .failure(let error): self?.handle(this: error)
                }
            } receiveValue: { [weak self] in
                self?.repository = $0
            }
            .store(in: &cancelBag)
        $repository
            .compactMap {$0}
            .flatMap { [weak self] repo -> AnyPublisher<Photo?, Never> in
                guard let this = self,
                      let thumbnail = repo.avatarURL else {return Empty().eraseToAnyPublisher()}
                return this.input.fetchImage(thumbnail)
                    .map {$0 as Photo?}
                    .replaceError(with: nil)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.thumbnail = $0
            }
            .store(in: &cancelBag)
    }

    func handle(this error: CustomError) {

    }
}
