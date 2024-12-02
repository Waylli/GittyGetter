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
            var navigationCoordinator: BaseNavigationCoordinator!
            var viewModelFactory: ViewModelFactory!
            let mockDataManager: DataManager = MockDataManager()
            let mockDatabase = MockDatabase()
            var rootViewController: UIViewController!

            beforeEach {
                navigationCoordinator = BaseNavigationCoordinator(rootViewController: UIViewController())
                rootViewController = presentViewController(view: navigationCoordinator).rootView
                setupViewModelFactory()
                setupCoordinator()
                print(coordinator!) // just to silence the warning
            }

            afterEach {
                cleanUp(rootView: rootViewController)
            }

            context("Tab Navigation") {
                it("navigates to the Favourites tab") {
                    let favouritesTab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.FavouritesTab)
                    favouritesTab?.tap()
                    assertViewExists(withAccessibilityLabel: FavouriteRepositoriesView.TestingIdentifiers.placeholderView)
                }

                it("navigates to the Organizations tab") {
                    let organizationsTab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.OrganizationsTab)
                    organizationsTab?.tap()
                    assertViewExists(withAccessibilityLabel: OrganizationsView.TestingIdentifiers.titleView)
                }

                it("navigates back to the Repositories tab") {
                    let organizationsTab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.OrganizationsTab)
                    organizationsTab?.tap()
                    assertViewExists(withAccessibilityLabel: OrganizationsView.TestingIdentifiers.titleView)
                    let repositoriesTab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.RepositoriesTab)
                    repositoriesTab?.tap()
                    assertViewExists(withAccessibilityLabel: RepositoriesView.TestingIdentifiers.backgroundView)
                }
            }

            context("View Navigation") {
                it("displays the Repository Details view") {
                    let repositoriesTab = viewTester().usingLabel(GittyTabView.TestingIdentifiers.RepositoriesTab)
                    repositoriesTab?.tap()
                    // Trigger repository selection event "manually" need to explore why tap is not working
                    coordinatorModel.events.repositorySelected.send(Repository.mock())
                    assertViewExists(withAccessibilityLabel: DetailedRepositoryView.TestingIdentifiers.mainView)
                    tester().waitForAnimationsToFinish()
                }
            }

            func setupCoordinator() {
                let modelInput = ApplicationCoordinatorModel
                    .Input(navigationCoordinator: navigationCoordinator, viewModelFactory: viewModelFactory, dataManager: mockDataManager)
                coordinatorModel = ApplicationCoordinatorModel(input: modelInput)
                coordinator = ApplicationCoordinator(with: coordinatorModel)
            }

            func setupViewModelFactory() {
                let factoryInput = ViewModelFactoryModel
                    .Input(database: mockDatabase, fetcher: MockFetcher(), configurtion: Configuration.standard())
                viewModelFactory = ViewModelFactory(with: ViewModelFactoryModel(with: factoryInput))
            }

        }
    }
}
