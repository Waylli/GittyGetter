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
            var localDatabase: LocalCoreDataDatabase!
            var cancelBag: CancelBag!
            beforeEach {
                cancelBag = CancelBag()
            }
            afterEach {
                localDatabase = nil
                cancelBag = nil
            }
            context("when initializing with a data model name") {
                it("should initialize with the default data model name") {
                    localDatabase = LocalCoreDataDatabase(dataModelName: LocalCoreDataDatabase._dataModelName)
                    var inited = false
                    waitUntil { done in
                        localDatabase
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
                    localDatabase = LocalCoreDataDatabase(dataModelName: String.random())
                    var inited = true
                    waitUntil(timeout: .seconds(10)) { done in
                        localDatabase
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
                    localDatabase = LocalCoreDataDatabase()
                }
                it("should be nil before initialization") {
                    expect(localDatabase.persistentContainer).to(beNil())
                }
                it("should not be nil after initialization") {
                    localDatabase.initialize().sink { _ in
                    } receiveValue: { _ in }
                        .store(in: &cancelBag)
                    expect(localDatabase.persistentContainer)
                        .toEventuallyNot(beNil(), timeout: .seconds(10))
                }
            }

            context("background context") {
                beforeEach {
                    localDatabase = LocalCoreDataDatabase()
                }
                it("should be nil before initialization") {
                    expect(localDatabase.backgroundContext).to(beNil())
                }
                it("should not be nil after initialization") {
                    localDatabase.initialize().sink { _ in
                    } receiveValue: { _ in }
                        .store(in: &cancelBag)
                    expect(localDatabase.backgroundContext)
                        .toEventuallyNot(beNil(), timeout: .seconds(10))
                }
            }

            context("reinitialization") {
                it("should not crash when called multiple times") {
                    localDatabase = LocalCoreDataDatabase()
                    waitUntil { done in
                        localDatabase.initialize().sink { _ in
                        } receiveValue: {  if $0 {done()} }
                            .store(in: &cancelBag)
                    }
                    waitUntil { done in
                        localDatabase.initialize().sink { _ in
                        } receiveValue: {  if $0 {done()} }
                            .store(in: &cancelBag)
                    }
                    waitUntil { done in
                        localDatabase.initialize().sink { _ in
                        } receiveValue: {  if $0 {done()} }
                            .store(in: &cancelBag)
                    }
                }
            }
        }
    }
}

