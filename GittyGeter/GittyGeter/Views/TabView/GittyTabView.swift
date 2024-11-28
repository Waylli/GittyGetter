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
    /// NE ZABORAVAJ FAVORITES Page
    var body: some View {
        TabView {
            RepositoriesView(with: model.makeRepositoriesViewModel())
                .tabItem {
                    Label {
                        Text("Repositories")
                    } icon: {
                        Image(uiImage: UIImage.fork)
                    }
                }
            OrganizationsView(with: model.makeOrganizationsViewModel())
                .tabItem {
                    Label("Organizations", systemImage: "building.2")
                }
        }
    }
}

#if DEBUG
import Combine

#Preview {
    let database = MockDatabase()
    let modelInput = GittyTabViewModel
        .Input(getAllOrganizations: database.getOrganizations,
               getRepositories: database.getRepositories(qury:for:),
               getFavoriteRepositories: database.getFavoriteRepositories,
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
