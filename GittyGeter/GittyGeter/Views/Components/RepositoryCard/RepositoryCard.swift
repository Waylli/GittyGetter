//
//  RepositoryCard.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI
import Kingfisher

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
                                .renderingMode(.template)
                                .foregroundStyle(model.input.configuration.colors.yellow)
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
        ZStack {
            // quick and dirty fix to handle "https://avatars.githubusercontent.com/u/49564161?v=4" not loaded correctly
            if let thumbnail = model.input.repository.avatarURL, let url = URL(string: thumbnail) {
                KFImage(url)
                    .resizable()
                    .frame(width: model.input.configuration.thumbnail.widht,
                           height: model.input.configuration.thumbnail.height)
                    .clipShape(
                        RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius)
                    )
            } else {
                ThumbnailComponent(thumbnail: Photo.star,
                                   configuration: model.input.configuration) {
                    ThumbnailBackgroundComponent()
                }
            }
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
                .foregroundStyle(model.input.configuration.colors.purpule)
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
