//
//  UIApplication+Helpers.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 30/11/2024.
//

import UIKit
@testable import GittyGeter

extension UIApplication {

    func getCurrentVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let finalVersion = "Version \(version) (\(buildNumber))"
        return finalVersion
    }

    static
    func getVisibleViewController() throws -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            throw CustomError.objectNotFound
        }
        return try findVisibleViewController(from: keyWindow.rootViewController)
    }

    static
    private func findVisibleViewController(from viewController: UIViewController?) throws -> UIViewController {
        if let presentedViewController = viewController?.presentedViewController {
            return try findVisibleViewController(from: presentedViewController)
        }
        if let navigationController = viewController as? UINavigationController {
            return try findVisibleViewController(from: navigationController.visibleViewController)
        }
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return try findVisibleViewController(from: selectedViewController)
        }
        guard let view = viewController else {
            throw CustomError.objectNotFound
        }
        return view
    }

}
