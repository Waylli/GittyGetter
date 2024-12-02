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
            HStack(alignment: .top) {
                TitleTextComponent(title: "Repositories")
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel(TestingIdentifiers.titleView)
                Spacer()
                SortingOrderButtonComponent(sortingOrder: model.sortingOrder,
                                            configuration: model.input.configuration)
                .accessibilityElement(children: .contain)
                .accessibilityLabel(TestingIdentifiers.sortingView)
                .onTapGesture {
                    model.sortingOrder = model.sortingOrder.next()
                }
            }
            SearchComponent(query: $model.query,
                            isFocused: $isSearching,
                            configuration: model.input.configuration)
            FilterOrganizationsComponent(model: model.makeFilterOrganizationsComponentModel())
                .accessibilityElement(children: .contain)
                .accessibilityLabel(TestingIdentifiers.searchComponent)
                .background {
                    model.input.configuration.colors.tappableClearColor
                }
            RepositoriesListView(with: model.makeRepositoriesListViewModel())
                .accessibilityElement(children: .contain)
                .accessibilityLabel(TestingIdentifiers.repositoryListComponent)
            Spacer()
        }
        .padding([.top, .leading, .trailing])
        .animation(.easeIn(duration: 0.1), value: model.currentFilteredOrganizations)
        .background {
            model.input.configuration
                .colors.tappableClearColor
                .onTapGesture {
                    if isSearching {
                        isSearching = false
                    }
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel(TestingIdentifiers.backgroundView)
        }
        .onAppear {
            model.sortingOrder = model.sortingOrder
        }
    }

}

extension RepositoriesView {
    struct TestingIdentifiers {
        static let titleView = "RepositoriesView.Title"
        static let sortingView = "RepositoriesView.SortingButton"
        static let searchComponent = "RepositoriesView.SearchView"
        static let repositoryListComponent = "RepositoriesView.RepositorytList"
        static let backgroundView = "RepositoriesView.BackgroundView"
     }
}

#if DEBUG && !TESTING
import Combine
#Preview {
    let database = MockDatabase()
    let modelInput = RepositoriesViewModel
        .Input(getAllOrganizations: database.getOrganizations,
               getRepositories: database.getRepositories(query:within:sortingOrder:),
               updateFavoriteStatus: database.updateFavoriteStatus(of:to:),
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = RepositoriesViewModel
        .Output(userSelectedRepository: PassthroughSubject())
    let model = RepositoriesViewModel(with: modelInput, and: modelOutput)
    RepositoriesView(with: model)
}
#endif
