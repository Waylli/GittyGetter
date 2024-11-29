//
//  BaseNavigationCoordinator.swift
//  SorareAssignment
//
//  Created by Petar Perkovski on 25/11/2024.
//

import UIKit

class BaseNavigationCoordinator: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
    }

    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(true, animated: false)
    }
}

extension BaseNavigationCoordinator: NavigationCoordinator {

    func push(view: UIViewController, animated: Bool = true) {
        pushViewController(view, animated: animated)
    }

    func present(view: UIViewController) {
        present(view, animated: true, completion: nil)
    }
    func dismissModal(animated: Bool, completition: @escaping () -> Void) {
        dismiss(animated: animated, completion: completition)
    }

    func pop(animated: Bool = true) {
        popViewController(animated: animated)
    }

    func popToRoot(animated: Bool) {
        popToRootViewController(animated: animated)
    }

    func set(views: [UIViewController], animated: Bool = false) {
        setViewControllers(views, animated: animated)
    }

}
