//
//  OrganizationsViewSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Foundation
import KIF
import Nimble
import Quick
import Combine
@testable import GittyGeter

class OrganizationsViewSpec: KIFSpec {
    override class func spec() {
        var view: OrganizationsView!
        var viewModel: OrganizationsViewModel!
        let database = LocalCoreDataDatabase()
        var cancelBag: CancelBag!
        beforeEach {
            cancelBag = CancelBag()
            _ = LocalDatabaseTestHelpers
                .performAndWait(publisher: database.initialize()).0
            viewModel = makeOrganizationsViewModel(with: database)
            view = OrganizationsView(with: viewModel)
            beforeEach {
                tester().waitForAnimationsToFinish()
                let viewController = try! UIApplication.getVisibleViewController()
                viewController.present(view.toViewController(), animated: false)
                tester().waitForAnimationsToFinish()
            }
            it("test") {
                sleep(5)
                _ = view
                _ = cancelBag
                expect(true).to(beTrue())
            }
        }
    }

    static
    func makeOrganizationsViewModel(with database: LocalCoreDataDatabase) -> OrganizationsViewModel {
        let modelInput = OrganizationsViewModel
            .Input(getAllOragnizations: database.getOrganizations,
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard())
        let modelOuptut = OrganizationsViewModel
            .Output(userSelectedOrganization: PassthroughSubject())
        return OrganizationsViewModel(with: modelInput, and: modelOuptut)
    }
}
