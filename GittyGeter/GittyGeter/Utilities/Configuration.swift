//
//  Configuration.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

struct Configuration {

    let thumbnail: Thumbnail
    let view: View

    struct Thumbnail {
        let widht: CGFloat
        let height: CGFloat
    }

    struct View {
        let cornerRadius: Double
    }

}

extension Configuration {
    static func standard() -> Configuration {
        Configuration(thumbnail: Thumbnail(widht: 65, height: 65),
                      view: View(cornerRadius: 15))
    }
}
