//
//  NavigationCoordinator.swift
//  SorareAssignment
//
//  Created by Petar Perkovski on 25/11/2024.
//

import Foundation
import UIKit

protocol NavigationCoordinator {
    func push(view: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func set(views: [UIViewController], animated: Bool)
    func present(view: UIViewController)
    func dismissModal(animated: Bool, completition: @escaping () -> Void)
}
