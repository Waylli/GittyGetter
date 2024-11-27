//
//  DescriptionTextComponent.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI

struct DescriptionTextComponent: View {

    let text: String?

    var body: some View {
        HStack {
            Text(text ?? "N/A")
                .font(.title3)
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    DescriptionTextComponent(text: "ds")
}
#endif
