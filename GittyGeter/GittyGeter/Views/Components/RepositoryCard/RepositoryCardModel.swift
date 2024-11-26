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

    }

    func handle(this error: CustomError) {

    }
}
