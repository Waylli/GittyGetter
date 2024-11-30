//
//  LocalDatabaseInitializationSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine
import Quick
import Nimble
@testable import GittyGeter

class LocalDatabaseInitializationSpec: QuickSpec {
    override class func spec() {
        describe("LocalDatabase Initialization") {
            var persistentRepositoryStore: LocalCoreDataDatabase!
            var cancelBag: CancelBag!
            beforeEach {
                cancelBag = CancelBag()
            }
            afterEach {
                persistentRepositoryStore = nil
                cancelBag = nil
            }
            context("when initializing with a data model name") {
                it("should initialize with the default data model name") {
                    persistentRepositoryStore = LocalCoreDataDatabase(dataModelName: LocalCoreDataDatabase._dataModelName)
                    var inited = false
                    waitUntil { done in
                        persistentRepositoryStore
                            .initialize()
                            .sink { _ in} receiveValue: {
                                inited = $0
                                done()
                            }
                            .store(in: &cancelBag)
                    }
                    expect(inited).to(beTrue())
                }
                it("should fail initialize with a custom data model name") {
                    persistentRepositoryStore = LocalCoreDataDatabase(dataModelName: String.random())
                    var inited = true
                    waitUntil(timeout: .seconds(10)) { done in
                        persistentRepositoryStore
                            .initialize()
                            .sink { result in
                                switch result {
                                case .finished:
                                    break
                                case .failure:
                                    inited = false
                                    done()
                                }
                            } receiveValue: { _ in
                            }
                            .store(in: &cancelBag)
                    }
                    expect(inited).toNot(beTrue())
                }
            }

            context("persistent container") {
                beforeEach {
                    persistentRepositoryStore = LocalCoreDataDatabase()
                }
                it("should be nil before initialization") {
                    expect(persistentRepositoryStore.persistentContainer).to(beNil())
                }
                it("should not be nil after initialization") {
                    persistentRepositoryStore.initialize().sink { _ in
                    } receiveValue: { _ in }
                        .store(in: &cancelBag)
                    expect(persistentRepositoryStore.persistentContainer)
                        .toEventuallyNot(beNil(), timeout: .seconds(10))
                }
            }

            context("background context") {
                beforeEach {
                    persistentRepositoryStore = LocalCoreDataDatabase()
                }
                it("should be nil before initialization") {
                    expect(persistentRepositoryStore.backgroundContext).to(beNil())
                }
                it("should not be nil after initialization") {
                    persistentRepositoryStore.initialize().sink { _ in
                    } receiveValue: { _ in }
                        .store(in: &cancelBag)
                    expect(persistentRepositoryStore.backgroundContext)
                        .toEventuallyNot(beNil(), timeout: .seconds(10))
                }
            }

            context("reinitialization") {
                it("should not crash when called multiple times") {
                    persistentRepositoryStore = LocalCoreDataDatabase()
                    waitUntil { done in
                        persistentRepositoryStore.initialize().sink { _ in
                        } receiveValue: {  if $0 {done()} }
                            .store(in: &cancelBag)
                    }
                    waitUntil { done in
                        persistentRepositoryStore.initialize().sink { _ in
                        } receiveValue: {  if $0 {done()} }
                            .store(in: &cancelBag)
                    }
                    waitUntil { done in
                        persistentRepositoryStore.initialize().sink { _ in
                        } receiveValue: {  if $0 {done()} }
                            .store(in: &cancelBag)
                    }
                }
            }
        }
    }
}
