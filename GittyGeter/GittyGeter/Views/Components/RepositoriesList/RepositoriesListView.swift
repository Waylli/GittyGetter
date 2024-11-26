//
//  RepositoriesListView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct RepositoriesListView: View {

    @ObservedObject private var model: RepositoriesListViewModel

    init(with model: RepositoriesListViewModel) {
        self.model = model
    }
    var body: some View {
        mainView()
    }

    private
    func mainView() -> AnyView {
        guard model.input.isScrollable else {
            return AnyView(list)
        }
        return AnyView(
            ScrollView {
                list
            }
        )
    }

    private
    var list: some View {
        LazyVStack(spacing: 16) {
            ForEach(model.input.repositories, id: \.self) { repo in
                RepositoryCard(with: model.createRepositoryCardModel(for: repo))
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.black.opacity(0.1))
                    }
            }
        }
    }
}

#if DEBUG
import Combine

#Preview {
    let modelInput = RepositoriesListViewModel
        .Input(isScrollable: true,
               repositories: Repository.mocks(),
               fetcher: MockFetcher(),
               configurration: Configuration.standard())
    let modelOutput = RepositoriesListViewModel
        .Output()
    let model = RepositoriesListViewModel(with: modelInput, and: modelOutput)
    RepositoriesListView(with: model)
}

#Preview {
    let modelInput = RepositoriesListViewModel
        .Input(isScrollable: false,
               repositories: Repository.mocks(),
               fetcher: MockFetcher(),
               configurration: Configuration.standard())
    let modelOutput = RepositoriesListViewModel
        .Output()
    let model = RepositoriesListViewModel(with: modelInput, and: modelOutput)
    RepositoriesListView(with: model)
}
#endif
