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
            TitleTextComponent(title: "Favourite")
            RepositoriesListView(with: model.makeRepositoriesListViewModel())
            Spacer()
        }
        .overlay {
            HStack {
                Spacer()
                VStack {
                    SortingOrderButtonComponent(sortingOrder: model.sortingOrder,
                                                configuration: model.input.configuration)
                    .onTapGesture {
                        model.sortingOrder = model.sortingOrder.next()
                    }
                    Spacer()

                }
            }
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
               configuration: Configuration.standard()) { _, _ in
            Just(true)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
    let modelOutput = FavouriteRepositoriesViewModel
        .Output(userSelectedRepository: PassthroughSubject())
    let model = FavouriteRepositoriesViewModel(with: modelInput,
                                              and: modelOutput)
    FavouriteRepositoriesView(with: model)
}
#endif
