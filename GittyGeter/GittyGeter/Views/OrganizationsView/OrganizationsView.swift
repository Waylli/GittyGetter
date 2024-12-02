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
                .accessibilityElement(children: .contain)
                .accessibilityLabel(TestingIdentifiers.titleView)
                .overlay {
                    HStack {
                        Spacer()
                        VStack {
                            Button {
                                print("aad orga not implemented")
                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.title)
                                    .padding([.top, .trailing])
                                    .foregroundStyle(model.input.configuration.colors.purpule)
                                    .accessibilityLabel(TestingIdentifiers.addOrgaButton)
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

extension OrganizationsView {
    struct TestingIdentifiers {
        static let titleView = "OrganizationsView.TitleView"
        static let addOrgaButton = "OrganizationsView.AddButton"
    }
}

#if DEBUG && !TESTING
import Combine
#Preview {
    let database = MockDatabase()
    let modelInput = OrganizationsViewModel
        .Input(getAllOragnizations: database.getOrganizations,
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = OrganizationsViewModel
        .Output(userSelectedOrganization: PassthroughSubject())
    let viewModel = OrganizationsViewModel(with: modelInput,
                                                   and: modelOutput)
    OrganizationsView(with: viewModel)
}
#endif
