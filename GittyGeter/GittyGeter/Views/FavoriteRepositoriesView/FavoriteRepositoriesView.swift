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
        ZStack {
            model.input.configuration.colors.tappableClearColor
                .accessibilityLabel(TestingIdentifiers.placeholderView)
            VStack {
                if model.repositories.count > 0 {
                    TitleTextComponent(title: "Favourite")
                        .accessibilityLabel(TestingIdentifiers.titleView)
                    RepositoriesListView(with: model.makeRepositoriesListViewModel())
                        .accessibilityLabel(TestingIdentifiers.repositoriesView)
                    Spacer()
                } else {
                    noRepos
                        .accessibilityLabel(TestingIdentifiers.noRepositoriesView)
                }
            }
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

    private
    var noRepos: some View {
        VStack(spacing: 64) {
            Text("No favorite repositories")
                .font(.largeTitle)
            Text("You can add a repository to favorites from repositories -> detail")
                .font(.body)
        }
    }
}

extension FavouriteRepositoriesView {
    struct TestingIdentifiers {
        static let placeholderView = "FavouriteRepositories.PlaceholderView"
        static let titleView = "FavouriteRepositories.TitleView"
        static let repositoriesView = "FavouriteRepositories.RepositoriesView"
        static let noRepositoriesView = "FavouriteRepositories.NoRepositories"
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
