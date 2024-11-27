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
    let modelInput = GittyTabViewModel
        .Input(allOrganizations: Just(Organization.mocks()).eraseToAnyPublisher(),
               getRepositories: { _, _ in
            Just(Repository.mocks())
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        },
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = GittyTabViewModel
        .Output()
    let model = GittyTabViewModel(with: modelInput,
                             and: modelOutput)
    GittyTabView(with: model)
}
#endif
