//
//  FavouriteRepositoriesView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 28/11/2024.
//

import SwiftUI

struct FavouriteRepositoriesView: View {

    @ObservedObject private var model: FavouriteRepositoriesViewModel

    init(with model: FavouriteRepositoriesViewModel) {
        self.model = model
    }

    var body: some View {
        VStack {
            TitleTextComponent(title: "Favourite Repositories")
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
    let modelInput = FavouriteRepositoriesViewModel
        .Input(getFavouriteRepositories: database.getFavouriteRepositories,
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = FavouriteRepositoriesViewModel
        .Output(userSelectedRepository: PassthroughSubject())
    let model = FavouriteRepositoriesViewModel(with: modelInput,
                                              and: modelOutput)
    FavouriteRepositoriesView(with: model)
}
#endif
