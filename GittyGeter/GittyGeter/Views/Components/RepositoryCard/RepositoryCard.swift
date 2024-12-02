//
//  RepositoryCard.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct RepositoryCard: View {

    @ObservedObject private var model: RepositoryCardModel

    init(with model: RepositoryCardModel) {
        self.model = model
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                thumbnail
                VStack(alignment: .leading) {
                    nameDescription
                    HStack {
                        HStack(alignment: .bottom, spacing: 4) {
                            Image(uiImage: UIImage.star)
                            Text("\(model.input.repository.stargazersCount)")
                                .fontWeight(.light)
                                .italic()
                                .font(.headline)
                        }
                        Spacer()
                        HStack(alignment: .bottom, spacing: 4) {
                            Image(uiImage: UIImage.fork)
                            Text("\(model.input.repository.forksCount)")
                                .fontWeight(.light)
                                .italic()
                                .font(.headline)
                        }
                        .padding([.trailing])
                    }
                }
                Spacer()
            }
            Text(model.input.repository.organizationName)
                .font(.title3)
                .italic()
            if let createdAt = model.input.repository.createdAt {
                Text(createdAt.readable())
                    .font(.footnote)
            }
        }
    }

    private
    var thumbnail: some View {
        guard let thumbnail = model.thumbnail else {
            return ThumbnailComponent(thumbnail: Photo.star,
                                      configuration: model.input.configuration) {
                ThumbnailBackgroundComponent()
            }
        }
        return ThumbnailComponent(thumbnail: thumbnail, configuration: model.input.configuration) {
            ThumbnailBackgroundComponent()
        }
    }
    private
    var nameDescription: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(model.input.repository.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                Text(model.input.repository.description ?? "")
                    .fontWeight(.light)
                    .italic()
                    .font(.headline)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
            }
            Spacer()
            Image(systemName: model.isFavorite ? "heart.fill" : "heart")
                .font(.largeTitle)
                .foregroundStyle(Color.orange)
            /// comment out if favorite status can be set from here
//                .onTapGesture {
//                    model.isFavoritePressed()
//                }
        }
    }
}

#if DEBUG && !TESTING
import Combine

#Preview {
    let modelInput = RepositoryCardModel
        .Input(repository: Repository.mock(),
               fetcher: MockFetcher(),
               configuration: Configuration.standard()) { _, _ in
            Just(true)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
    let modelOutput = RepositoryCardModel
        .Output()
    let model = RepositoryCardModel(with: modelInput,
                                    and: modelOutput)
    RepositoryCard(with: model)
}
#endif
