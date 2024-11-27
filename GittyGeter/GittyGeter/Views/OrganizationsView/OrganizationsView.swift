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
            TitleTextComponent(title: "Organizations")
                .overlay {
                    HStack {
                        Spacer()
                        VStack {
                            Button {

                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.title)
                                    .padding([.top, .trailing])
                            }
                            Spacer()
                        }
                    }
                }
            OrganizationsList(with: model.makeOrganizationsListModel())
            Spacer()
        }
        .padding()
    }

}

#if DEBUG
import Combine
#Preview {
    let orgs = Just(Organization.mocks())
        .eraseToAnyPublisher()
    let modelInput = OrganizationsViewModel
        .Input(oragnizations: orgs,
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = OrganizationsViewModel
        .Output(userSelectedOrganization: PassthroughSubject())
    let viewModel = OrganizationsViewModel(with: modelInput,
                                                   and: modelOutput)
    OrganizationsView(with: viewModel)
}
#endif
