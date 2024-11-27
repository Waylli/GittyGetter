//
//  RepositoriesView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct RepositoriesView: View {

    @ObservedObject private var model: RepositoriesViewModel
    @FocusState var isSearching: Bool

    init(with model: RepositoriesViewModel) {
        self.model = model
    }

    var body: some View {
        VStack {
            TitleTextComponent(title: "Repositories")
            SearchComponent(query: $model.query,
                            isFocused: $isSearching,
                            configuration: model.input.configuration)
            FilterOrganizationsComponent(with: model.createFilterOrganizationsComponentModel())
            RepositoriesListView(with: model.createRepositoriesListViewModel())
            Spacer()
        }
        .padding()
        .animation(.easeIn(duration: 0.1), value: model.currentFilteredOrganizations)
        .background {
            model.input.configuration
                .colors.tappableClearColor
                .onTapGesture {
                    if isSearching {
                        isSearching = false
                    }
                }
        }
    }

}

#if DEBUG
import Combine
#Preview {
    let orgs = Just(Organization.mocks()).eraseToAnyPublisher()
    let modelInput = RepositoriesViewModel
        .Input(allOrganizations: orgs, getRepositories: { _, _ in
            Just(Repository.mocks())
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        },
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = RepositoriesViewModel
        .Output()
    let model = RepositoriesViewModel(with: modelInput, and: modelOutput)
    RepositoriesView(with: model)
}
#endif
