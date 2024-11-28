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
            FilterOrganizationsComponent(with: model.makeFilterOrganizationsComponentModel())
            RepositoriesListView(with: model.makeRepositoriesListViewModel())
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
    let database = MockDatabase()
    let modelInput = RepositoriesViewModel
        .Input(getAllOrganizations: database.getOrganizations,
               getRepositories: database.getRepositories(query:within:),
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = RepositoriesViewModel
        .Output(userSelectedRepository: PassthroughSubject())
    let model = RepositoriesViewModel(with: modelInput, and: modelOutput)
    RepositoriesView(with: model)
}
#endif
