//
//  SceneDelegate.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // make a Transient view
        let navigator = BaseNavigationCoordinator(rootViewController: UIViewController())
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigator
        self.window = window
        window.makeKeyAndVisible()
        applicationCoordinator = createApplicationCoordinator(with: navigator)
    }

}

private
extension SceneDelegate {
    func createApplicationCoordinator(with navigationController: NavigationCoordinator) -> ApplicationCoordinator {
        let persistentRepositoryStore = LocalCoreDataDatabase()
        let service = GitHubAPIProvider()
        let appDataManagerModelInput = AppDataManagerModel
            .Input(persistentRepositoryStore: persistentRepositoryStore,
                   repositoryProvider: persistentRepositoryStore,
                   networkService: service)
        let appDataManagerModel = AppDataManagerModel(with: appDataManagerModelInput)
        let appDataManager = AppDataManager(with: appDataManagerModel)
        let factoryModelInput = ViewModelFactoryModel
            .Input(database: persistentRepositoryStore,
                   fetcher: AppFetcher(),
                   configurtion: Configuration.standard())
        let factoryModel = ViewModelFactoryModel(with: factoryModelInput)
        let viewModelFactory = ViewModelFactory(with: factoryModel)
        let modelInput = ApplicationCoordinatorModel
            .Input(navigationCoordinator: navigationController,
                   viewModelFactor: viewModelFactory,
                   dataManager: appDataManager)
        let applicationCoordinatorModel = ApplicationCoordinatorModel(with: modelInput)
        return ApplicationCoordinator(with: applicationCoordinatorModel)
    }
}
