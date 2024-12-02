//
//  SortingOrderButtonComponent.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 30/11/2024.
//

import SwiftUI

struct SortingOrderButtonComponent: View {

    let sortingOrder: SortingOrder
    let configuration: Configuration

    var body: some View {
        Text(sortingOrder.readable())
            .foregroundStyle(Color.primary)
            .font(.callout)
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: configuration.view.cornerRadius)
                    .foregroundStyle(.blue)
            }
    }
}

#if DEBUG && !TESTING
#Preview {
    SortingOrderButtonComponent(sortingOrder: .standard, configuration: Configuration.standard())
}
#endif
