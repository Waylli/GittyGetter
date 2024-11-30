//
//  OrganizationCardModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

class OrganizationCardModel: ObservableObject {

    @Published var thumbnail = Photo.star

    private var cancelBag = CancelBag()

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
        bind()
    }
}

extension OrganizationCardModel {

    struct Input {
        let organization: Organization
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {

    }
}

private
extension OrganizationCardModel {

    func bind() {
        guard let thumbnailPath = input.organization.avatarURL else {
            return
        }
        input.fetcher.fetchPhoto(from: thumbnailPath)
            .sink { _ in

            } receiveValue: { [weak self] in
                self?.thumbnail = $0
            }
            .store(in: &cancelBag)
    }
}
