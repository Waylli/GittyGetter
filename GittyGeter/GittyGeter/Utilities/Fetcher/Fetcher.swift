//
//  Fetcher.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import Combine

protocol Fetcher {
    func fetchPhoto(from string: String) -> AnyPublisher<Photo, CustomError>
}

#if DEBUG
class MockFetcher: Fetcher {

    var canFetch: Bool

    init(canFetch: Bool = true) {
        self.canFetch = canFetch
    }

    func fetchPhoto(from string: String) -> AnyPublisher<Photo, CustomError> {
        guard canFetch else {
            return Fail(error: CustomError.networkError).eraseToAnyPublisher()
        }
        return Just(Photo.star)
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }
}
#endif
