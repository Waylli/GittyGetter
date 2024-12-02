//
//  BackNavigationComponenet.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI

struct BackNavigationComponenet: View {

    let configuration: Configuration
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                configuration.colors.tappableClearColor
                HStack {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.primary)
                        .frame(height: proxy.size.height * 0.7)
                        .accessibilityLabel(TestingIdentifiers.backButton)
                    Spacer()
                }
            }
        }
        .frame(width: configuration.buttons.backButtonSize.width,
               height: configuration.buttons.backButtonSize.height)
    }
}

extension BackNavigationComponenet {
    struct TestingIdentifiers {
        static let backButton = "BackNavigationComponenet.Back.Button"
    }
}
#if DEBUG
#Preview {
    BackNavigationComponenet(configuration: Configuration.standard())
}
#endif
