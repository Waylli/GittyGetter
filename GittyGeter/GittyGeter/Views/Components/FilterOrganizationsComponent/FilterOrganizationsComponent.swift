//
//  FilterOrganizationsComponent.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI
import WrappingHStack

struct FilterOrganizationsComponent: View {

    private let model: FilterOrganizationsComponentModel

    init(with model: FilterOrganizationsComponentModel) {
        self.model = model
    }

    var body: some View {
        VStack(spacing: 16) {
            if !model.input.currentFilteredOrganizations.isEmpty {
                VStack(spacing: 7) {
                    HStack {
                        filteredOrganizationsView
                        Spacer()
                    }
                    if model.input.currentFilteredOrganizations.count > 1 {
                        clearLabel
                    }
                }
                Divider()
            }
            if !model.input.availableOrganizations.isEmpty {
                availableOrganizations
                Divider()
            }
        }
    }

    private
    var filteredOrganizationsView: some View {
        WrappingHStack(model.input.currentFilteredOrganizations, id: \.self) { org in
            HStack {
                Text(org.name)
                    .font(.footnote)
                Image(systemName: "xmark.circle")
            }
            .padding(4)
            .background {
                RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius)
                    .foregroundStyle(Color.blue.opacity(0.4))
            }
            .padding([.top, .bottom], 4)
            .onTapGesture {
                model.removeFromFiltered(this: org)
            }
        }
    }

    private
    var clearLabel: some View {
        Text("Clear all filters")
            .font(.callout)
            .padding(6)
            .padding([.leading, .trailing], 16)
            .background {
                RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius)
                    .foregroundStyle(Color.red.opacity(0.6))
            }
            .onTapGesture {
                model.pressedClearAll()
            }
    }

    private
    var availableOrganizations: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(model.input.availableOrganizations,
                        id: \.self) { organization in
                    Text(organization.name)
                        .italic()
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding([.top, .bottom], 8)
                        .padding([.leading, .trailing], 12)
                        .background {
                            RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius)
                                .foregroundStyle(Color.primary.opacity(0.25))
                        }
                        .onTapGesture {
                            model.applyFilterFrom(this: organization)
                        }
                }
            }
        }
    }
}

#if DEBUG
import Combine

#Preview {
    let modelInput = FilterOrganizationsComponentModel
        .Input(availableOrganizations: Organization.mocks(count: 20),
               currentFilteredOrganizations: Organization.mocks(),
               configuration: Configuration.standard())
    let modelOutput = FilterOrganizationsComponentModel
        .Output(removeFilteredOrganization: PassthroughSubject(),
                removeAllFilteredOrganizations: PassthroughSubject(),
                applyFilterFromOrganization: PassthroughSubject())
    let model = FilterOrganizationsComponentModel(with: modelInput, and: modelOutput)
    FilterOrganizationsComponent(with: model)
}
#endif
