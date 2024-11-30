//
//  Configuration.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import SwiftUI

struct Configuration {

    let thumbnail: Thumbnail
    let view: View
    let buttons: Buttons
    let colors = Colors()
    let settings: Settings

    struct Settings {
        let sorting: Sorting
        struct Sorting {
            let forFavorites: SortingOrder

            init(forFavorites: SortingOrder) {
                self.forFavorites = forFavorites
            }
        }
    }

    struct Thumbnail {
        let widht: CGFloat
        let height: CGFloat
    }

    struct View {
        let cornerRadius: Double
    }

    struct Colors {
        let tappableClearColor = Color.white.opacity(0.002)
    }

    struct Buttons {
        let smallSize: CGSize
        let backButtonSize: CGSize
    }

}

extension Configuration {
    static func standard() -> Configuration {
        let settings = Configuration.Settings(sorting: .init(forFavorites: .standard))
        return Configuration(thumbnail: Thumbnail(widht: 65, height: 65),
                             view: View(cornerRadius: 15),
                             buttons: Buttons(smallSize: CGSize(width: 44, height: 44),
                                              backButtonSize: CGSize(width: 55, height: 44)),
                             settings: settings)
    }
}
