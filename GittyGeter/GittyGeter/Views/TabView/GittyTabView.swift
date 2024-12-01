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
                .accessibilityLabel(TestingIdentifiers.repositoriesView)
                .tabItem {
                    Label {
                        Text("Repositories")
                    } icon: {
                        Image(uiImage: UIImage.fork)
                    }
                }
                .tag(GittyTabViewTab.repositories)
            FavouriteRepositoriesView(with: model.makeFavouriteRepositoriesViewModel())
                .accessibilityLabel(TestingIdentifiers.favouriteRepositoriesView)
                .tabItem {
                    Label {
                        Text("Favourites")
                    } icon: {
                        Image(systemName: "heart.fill")
                    }
                }
                .tag(GittyTabViewTab.favorite)
            OrganizationsView(with: model.makeOrganizationsViewModel())
                .accessibilityLabel(TestingIdentifiers.organizationsView)
                .tabItem {
                    Label("Organizations", systemImage: "building.2")
                }
                .tag(GittyTabViewTab.organizations)
        }
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
