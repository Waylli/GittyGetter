//
//  View+Helper.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI

extension View {
    func toViewController() -> UIViewController {
        UIHostingController(rootView: self)
    }
}
