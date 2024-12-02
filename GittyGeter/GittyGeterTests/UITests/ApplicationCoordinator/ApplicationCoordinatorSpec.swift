//
//  ApplicationCoordinatorSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 01/12/2024.
//

import Foundation
import KIF
import Nimble
import Quick
import UIKit
@testable import GittyGeter

class ApplicationCoordinatorSpec: KIFSpec {
    
    override class func spec() {
        describe("ApplicationCoordinator") {
            var coordinator: ApplicationCoordinator!
            var coordinatorModel: ApplicationCoordinatorModel!
            var navigator: BaseNavigationCoordinator!
            var factory: ViewModelFactory!
            let dataManager: DataManager = MockDataManager()
            let database = MockDatabase()
            var rootView: UIViewController!
            
            beforeEach {
                navigator = BaseNavigationCoordinator(rootViewController: UIViewController())
                rootView = presentViewController(view: navigator).rootView
                initFactory()
                initCoordinator()
                print(coordinator!)
            }
            afterEach {
                cleanUp(rootView: rootView)
            }
            context("tab navigation") {
                it("goes to favourites") {
                    let tab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.FavouritesTab)
                    tab?.tap()
                    assertViewExists(withAccessibilityLabel: FavouriteRepositoriesView.TestingIdentifiers.placeholderView)
                }
                it("goes to organizations") {
                    let tab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.OrganizationsTab)
                    tab?.tap()
                    assertViewExists(withAccessibilityLabel: OrganizationsView.TestingIdentifiers.titleView)
                }
                it("goes back to all repositories") {
                    let tab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.OrganizationsTab)
                    tab?.tap()
                    assertViewExists(withAccessibilityLabel: OrganizationsView.TestingIdentifiers.titleView)
                    let repoTab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.RepositoriesTab)
                    repoTab?.tap()
                    assertViewExists(withAccessibilityLabel: RepositoriesView.TestingIdentifiers.backgroundView)
                }
            }

            context("view navigation") {
                it("can show repo detail") {
                    let repoTab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.RepositoriesTab)
                    repoTab?.tap()
                    /// need to find underlying uiElement to have  KIF tap and trigger the event
                    coordinatorModel.events.repositorySelected.send(Repository.mock())
                    assertViewExists(withAccessibilityLabel: DetailedRepositoryView.TestingIdentifiers.mainView)
                    tester().waitForAnimationsToFinish()
                }
            }

            
            func initCoordinator() {
                let modelInput = ApplicationCoordinatorModel
                    .Input(navigationCoordinator: navigator, viewModelFactory: factory, dataManager: dataManager)
                coordinatorModel = ApplicationCoordinatorModel(input: modelInput)
                coordinator = ApplicationCoordinator(with: coordinatorModel)
            }
            
            func initFactory() {
                let input = ViewModelFactoryModel
                    .Input(database: database, fetcher: MockFetcher(), configurtion: Configuration.standard())
                factory = ViewModelFactory(with: ViewModelFactoryModel(with: input))
            }
        }
        
    }
}
