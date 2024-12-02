//
//  LocalDatabaseTestHelpers.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

struct LocalDatabaseTestHelpers {

    static func performAndWait<T: Decodable>(publisher: AnyPublisher<T, CustomError>,
                                           timeout: Int = 5) -> (T?, CancelBag) {
        var fetchedValue: T?
        var cancelBag = CancelBag()
        waitUntil(timeout: .seconds(timeout)) { done in
            publisher
                .sink { result in
                    switch result {
                    case .finished: break
                    case .failure(let error): fatalError(error.localizedDescription)
                    }
                } receiveValue: {
                    fetchedValue = $0
                    done()
                }
                .store(in: &cancelBag)
        }
        expect(fetchedValue).notTo(beNil())
        return (fetchedValue, cancelBag)
    }

    static func throwingPerformAndWait<T: Decodable>(publisher: AnyPublisher<T, CustomError>,
                                                     timeout: Int = 1) throws -> (T?, CancelBag) {
        var fetchedValue: T?
        var cancelBag = CancelBag()
        var capturedError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    capturedError = error
                case .finished:
                    break
                }
                semaphore.signal()
            }, receiveValue: { value in
                fetchedValue = value
            })
            .store(in: &cancelBag)
        if semaphore.wait(timeout: .now() + .seconds(timeout)) == .timedOut {
            throw CustomError.dataMappingFailed
        }
        if let error = capturedError {
            throw error
        }
        return (fetchedValue, cancelBag)
    }

}
