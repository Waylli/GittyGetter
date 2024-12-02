//
//  OrganizationsList.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct OrganizationsList: View {

    @ObservedObject private var model: OrganizationsListModel

    init(with model: OrganizationsListModel) {
        self.model = model
    }

    var body: some View {
        ScrollView {
            list
        }
    }

    private
    var list: some View {
        LazyVStack {
            ForEach(model.input.organizations,
                    id: \.self) { organization in
                OrganizationCard(with: model.makeOrganizationCardModel(for: organization))
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius)
                            .foregroundStyle(Color.primary.opacity(0.15))
                    }
                    .onTapGesture {
                        model.userSelected(this: organization)
                    }
            }
        }
    }
}

#if DEBUG && !TESTING
import Combine
#Preview {
    let modelInput = OrganizationsListModel
        .Input(organizations: Organization.mocks(),
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = OrganizationsListModel
        .Output(userSelectedOrganization: PassthroughSubject())
    let model = OrganizationsListModel(with: modelInput,
                                       and: modelOutput)
    OrganizationsList(with: model)
}
#endif
