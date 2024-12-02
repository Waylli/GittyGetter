//
//  FilterOrganizationsComponent.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI
import WrappingHStack

struct FilterOrganizationsComponent: View {

    private let viewModel: FilterOrganizationsComponentModel

    init(model: FilterOrganizationsComponentModel) {
        self.viewModel = model
    }

    var body: some View {
        VStack(spacing: 16) {
            if !viewModel.input.filteredOrganizations.isEmpty {
                filteredOrganizationsSection
            }
            if !viewModel.input.availableOrganizations.isEmpty {
                availableOrganizationsSection
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(TestingIdentifiers.mainView)
    }

    private var filteredOrganizationsSection: some View {
        VStack(spacing: 7) {
            HStack {
                filteredOrganizationsView
                Spacer()
            }
            if viewModel.input.filteredOrganizations.count > 1 {
                clearFiltersButton
                    .accessibilityLabel(TestingIdentifiers.clearFiltersButton)
            }
        }
        .padding(.bottom, 8)
        .overlay(Divider(), alignment: .bottom)
    }

    private var availableOrganizationsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.input.availableOrganizations, id: \.self) { organization in
                    organizationChip(for: organization)
                }
            }
        }
        .overlay(Divider(), alignment: .top)
    }

    private var filteredOrganizationsView: some View {
        WrappingHStack(viewModel.input.filteredOrganizations, id: \.self) { organization in
            organizationChip(for: organization)
                .onTapGesture {
                    viewModel.output.removeFilteredOrganization.send(organization)
                }
                .accessibilityLabel("\(TestingIdentifiers.clearOrgaButton)")
        }
    }

    private var clearFiltersButton: some View {
        Text("Clear all filters")
            .font(.callout)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: viewModel.input.configuration.view.cornerRadius)
                .foregroundColor(.red.opacity(0.6)))
            .onTapGesture {
                viewModel.clearAllFilters()
            }
    }

    private func organizationChip(for organization: Organization) -> some View {
        Text(organization.name)
            .font(.headline)
            .italic()
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: viewModel.input.configuration.view.cornerRadius)
                .foregroundColor(.blue.opacity(0.4)))
    }
}

extension FilterOrganizationsComponent {
    struct TestingIdentifiers {
        static let mainView = "FilterOrganizationsComponent.MainView"
        static let clearFiltersButton = "FilterOrganizationsComponent.ClearFiltersButton"
        static let clearOrgaButton = "FilterOrganizationsComponentOrga.Chip"
    }
}
