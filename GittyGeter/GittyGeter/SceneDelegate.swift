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
        let factoryModelInput = ViewModelFactoryModel
            .Input(database: MockDatabase(),
                   fetcher: MockFetcher(),
                   configurtion: Configuration.standard())
        let factoryModel = ViewModelFactoryModel(with: factoryModelInput)
        let viewModelFactory = ViewModelFactory(with: factoryModel)
        let modelInput = AppManagerModel
            .Input(navigationCoordinator: navigationController, viewModelFactor: viewModelFactory)
        let appManagerModel = AppManagerModel(with: modelInput)
        return AppManager(with: appManagerModel)
    }
}
