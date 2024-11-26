//
//  OrganizationsView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct OrganizationsView: View {

    @ObservedObject private var model: OrganizationsViewModel

    init(with model: OrganizationsViewModel) {
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
            Text("Organizations")
                .font(.title)
                .bold()
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    let modelInput = OrganizationsViewModel
        .Input()
    let modelOutput = OrganizationsViewModel
        .Output()
    let viewModel = OrganizationsViewModel(with: modelInput,
                                                   and: modelOutput)
    OrganizationsView(with: viewModel)
}
#endif
