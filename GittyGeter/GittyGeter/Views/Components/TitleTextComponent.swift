//
//  TitleTextComponent.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI

struct TitleTextComponent: View {

    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

#if DEBUG && !TESTING
#Preview {
    TitleTextComponent(title: "Repos")
}
#endif
