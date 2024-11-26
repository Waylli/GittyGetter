//
//  FavoriteOrganizationsView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct FavoriteOrganizationsView: View {

    @ObservedObject private var model: FavoriteOrganizationsViewModel

    init(with model: FavoriteOrganizationsViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .padding([.top, .trailing])
                }

            }
            topView
            Spacer()
        }
    }

    private
    var topView: some View {
        HStack {
            Spacer()
            Text("Favorite Organizations")
                .font(.title)
                .bold()
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    let modelInput = FavoriteOrganizationsViewModel
        .Input()
    let modelOutput = FavoriteOrganizationsViewModel
        .Output()
    let viewModel = FavoriteOrganizationsViewModel(with: modelInput,
                                                   and: modelOutput)
    FavoriteOrganizationsView(with: viewModel)
}
#endif
