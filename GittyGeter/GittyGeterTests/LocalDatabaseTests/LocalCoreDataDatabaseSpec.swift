//
//  LocalCoreDataDatabaseSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 28/11/2024.
//

import Foundation
import Combine
import Quick
import Nimble
@testable import GittyGeter

class LocalCoreDataDatabaseSpec: QuickSpec {
    override class func spec() {
        describe("LocalCoreDataDatabase") {
            var localDatabase: LocalCoreDataDatabase!
            var cancelBag: CancelBag!
            beforeEach {
                localDatabase = LocalCoreDataDatabase()
                cancelBag = CancelBag()
            }
            afterEach {
                cancelBag = nil
                localDatabase = nil
            }
            it("can create NSPersistentContainer") {
                localDatabase.initialize()
                    .sink { _ in } receiveValue: { _ in }
                    .store(in: &cancelBag)
                expect(localDatabase.persistentContainer).toEventuallyNot(beNil(), timeout: .seconds(1))
                expect(localDatabase.backgroundContext).toEventuallyNot(beNil(), timeout: .seconds(1))

            }
        }
    }
}
