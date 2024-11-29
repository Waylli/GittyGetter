//
//  SceneDelegate.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appManager: AppManager?

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
        appManager = createAppManager(with: navigator)
    }

}

private
extension SceneDelegate {
    func createAppManager(with navigationController: NavigationCoordinator) -> AppManager {
        let localDatabase = LocalCoreDataDatabase()
        let service = GitHubAPIProvider()
        let appDataManagerModelInput = AppDataManagerModel
            .Input(localDatabase: localDatabase,
                   networkService: service)
        let appDataManagerModel = AppDataManagerModel(with: appDataManagerModelInput)
        let appDataManager = AppDataManager(with: appDataManagerModel)
        let factoryModelInput = ViewModelFactoryModel
            .Input(database: localDatabase,
                   fetcher: MockFetcher(),
                   configurtion: Configuration.standard())
        let factoryModel = ViewModelFactoryModel(with: factoryModelInput)
        let viewModelFactory = ViewModelFactory(with: factoryModel)
        let modelInput = AppManagerModel
            .Input(navigationCoordinator: navigationController,
                   viewModelFactor: viewModelFactory,
                   dataManager: appDataManager)
        let appManagerModel = AppManagerModel(with: modelInput)
        return AppManager(with: appManagerModel)
    }
}
