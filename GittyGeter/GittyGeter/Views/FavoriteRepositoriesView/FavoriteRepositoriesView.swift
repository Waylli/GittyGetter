//
//  FavoriteRepositoriesView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import SwiftUI

struct FavoriteRepositoriesView: View {

    @ObservedObject private var model: FavoriteRepositoriesViewModel

    init(with model: FavoriteRepositoriesViewModel) {
        self.model = model
    }

    var body: some View {
        VStack {
            TitleTextComponent(title: "Favorite Repositories")
            RepositoriesListView(with: model.makeRepositoriesListViewModel())
            Spacer()
        }
        .padding()
    }
}

#if DEBUG
import Combine

#Preview {
    let database = MockDatabase()
    let modelInput = FavoriteRepositoriesViewModel
        .Input(getFavoriteRepositories: database.getFavoriteRepositories,
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = FavoriteRepositoriesViewModel
        .Output(userSelectedRepository: PassthroughSubject())
    let model = FavoriteRepositoriesViewModel(with: modelInput,
                                              and: modelOutput)
    FavoriteRepositoriesView(with: model)
}
#endif
