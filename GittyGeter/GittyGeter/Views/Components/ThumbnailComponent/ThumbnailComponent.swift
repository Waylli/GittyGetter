//
//  ThumbnailComponent.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import SwiftUI

struct ThumbnailComponent<Content: View>: View {

    let thumbnail: UIImage
    let configuration: Configuration
    @ViewBuilder var background: () -> Content

    var body: some View {
        Image(uiImage: thumbnail)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: configuration.thumbnail.widht,
                   height: configuration.thumbnail.height)
            .background {
                background()
            }
            .clipShape (
                RoundedRectangle(cornerRadius: configuration.view.cornerRadius)
            )
    }
}

#if DEBUG
#Preview {
    ThumbnailComponent(thumbnail: UIImage.star, configuration: .standard()) {
        Color.red
    }
}
#endif
