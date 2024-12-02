//
//  GittyTabView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI

struct GittyTabView: View {

    @ObservedObject private var model: GittyTabViewModel

    init(with model: GittyTabViewModel) {
        self.model = model
    }

    var body: some View {
        TabView(selection: $model.selectedTab) {
            RepositoriesView(with: model.makeRepositoriesViewModel())
                .accessibilityElement(children: .contain)
                .accessibilityLabel(TestingIdentifiers.repositoriesView)
                .tabItem {
                    Label {
                        Text("Repositories")
                    } icon: {
                        Image(uiImage: UIImage.fork)
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel(TestingIdentifiers.RepositoriesTab)
                    }
                }
                .tag(GittyTabViewTab.repositories)
            FavouriteRepositoriesView(with: model.makeFavouriteRepositoriesViewModel())
                .accessibilityElement(children: .contain)
                .accessibilityLabel(TestingIdentifiers.favouriteRepositoriesView)
                .tabItem {
                    Label {
                        Text("Favourites")
                    } icon: {
                        Image(systemName: "heart.fill")
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel(TestingIdentifiers.FavouritesTab)
                    }
                }
                .tag(GittyTabViewTab.favorite)
            OrganizationsView(with: model.makeOrganizationsViewModel())
                .accessibilityElement(children: .contain)
                .accessibilityLabel(TestingIdentifiers.organizationsView)
                .tabItem {
                    Label("Organizations", systemImage: "building.2")
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel(TestingIdentifiers.OrganizationsTab)
                }
                .tag(GittyTabViewTab.organizations)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(TestingIdentifiers.tabView)
    }
}

extension GittyTabView {

    enum GittyTabViewTab {
           case repositories
           case favorite
           case organizations
       }

    struct TestingIdentifiers {
        static let repositoriesView = "GittyTabView.RepositoriesView"
        static let favouriteRepositoriesView = "GittyTabView.FavouriteRepositoriesView"
        static let organizationsView = "FavouriteRepositoriesView.OrganizationsView"
        static let tabView = "GittyTabView.TabView"
        static let RepositoriesTab = "GittyTabView.RepositoriesTab"
        static let FavouritesTab = "GittyTabView.FavouritesTab"
        static let OrganizationsTab = "GittyTabView.OrganizationsTab"
    }
}

#if DEBUG
import Combine

#Preview {
    let database = MockDatabase()
    let mockLocalDatabase = MockLocalDatabase()
    let modelInput = GittyTabViewModel
        .Input(getAllOrganizations: database.getOrganizations,
               getRepositories: database.getRepositories(query:within:sortingOrder:),
               getFavouriteRepositories: database.getFavouriteRepositories(with:),
               updateFavoriteStatus: mockLocalDatabase.updateFavoriteStatus(of:to:),
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = GittyTabViewModel
        .Output(userSelectedRepository: PassthroughSubject(),
                userSelectedOrganization: PassthroughSubject())
    let model = GittyTabViewModel(with: modelInput,
                             and: modelOutput)
    GittyTabView(with: model)
}
#endif
