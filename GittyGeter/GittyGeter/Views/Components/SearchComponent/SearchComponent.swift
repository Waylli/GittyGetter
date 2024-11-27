//
//  SearchComponent.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI

struct SearchComponent: View {

    @Binding var query: String
    let isFocused: FocusState<Bool>.Binding
    let placeholder: String
    let configuration: Configuration

    init(query: Binding<String>,
         isFocused: FocusState<Bool>.Binding,
         placeholder: String = NSLocalizedString("🔍 search", comment: ""),
         configuration: Configuration) {
        self._query = query
        self.isFocused = isFocused
        self.placeholder = placeholder
        self.configuration = configuration
    }

    var body: some View {
        TextField(text: $query) {
            Text(placeholder)
        }
        .textFieldStyle(.roundedBorder)
        .focused(isFocused)
        .overlay {
            if isFocused.wrappedValue {
                HStack {
                    Spacer()
                    ZStack {
                        configuration
                            .colors
                            .tappableClearColor
                        Image(systemName: "xmark.circle")
                            .font(.footnote)
                    }
                    .frame(width: configuration.buttons.smallSize.width,
                           height: configuration.buttons.smallSize.height)
                    .onTapGesture {
                        if isFocused.wrappedValue {
                            isFocused.wrappedValue = false
                            query = ""
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    struct PreviewWrapper: View {
        @State private var query = "petar"
        @FocusState private var isFocused: Bool

        var body: some View {
            SearchComponent(
                query: $query,
                isFocused: $isFocused,
                configuration: Configuration.standard()
            )
        }
    }

    return PreviewWrapper()
}
#endif
