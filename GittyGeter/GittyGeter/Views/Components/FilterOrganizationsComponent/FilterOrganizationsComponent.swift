//
//  FilterOrganizationsComponent.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct FilterOrganizationsComponent: View {

    private let model: FilterOrganizationsComponentModel

    init(with model: FilterOrganizationsComponentModel) {
        self.model = model
    }

    var body: some View {
        VStack {

        }
    }
}

#if DEBUG
import Combine

#Preview {
    let modelInput = FilterOrganizationsComponentModel
        .Input(availableOrganizations: Organization.mocks(count: 20), currentFilteredOrganizations: Organization.mocks())
    let modelOutput = FilterOrganizationsComponentModel
        .Output(removeFilteredOrganization: PassthroughSubject(),
                removeAllFilteredOrganizations: PassthroughSubject(),
                applyFilterToOrganization: PassthroughSubject())
    let model = FilterOrganizationsComponentModel(with: modelInput, and: modelOutput)
    FilterOrganizationsComponent(with: model)
}
#endif
