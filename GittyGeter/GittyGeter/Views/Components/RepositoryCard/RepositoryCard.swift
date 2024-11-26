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
                getThumbnail()
                    .resizable()
                    .frame(width: 65, height: 65)
                    .aspectRatio(contentMode: .fit)
                    .background(Color.red)
                VStack(alignment: .leading) {
                    Text(model.repository?.name ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(model.repository?.description ?? "")
                        .fontWeight(.light)
                        .italic()
                        .font(.headline)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                    HStack {
                        HStack(alignment: .bottom, spacing: 4) {
                            Image(uiImage: UIImage.star)
                            Text("\(model.repository?.stargazersCount ?? 0)")
                                .fontWeight(.light)
                                .italic()
                                .font(.headline)
                        }
                        Spacer()
                        HStack (alignment: .bottom, spacing: 4) {
                            Image(uiImage: UIImage.fork)
                            Text("\(model.repository?.forksCount ?? 0)")
                                .fontWeight(.light)
                                .italic()
                                .font(.headline)
                        }
                        .padding([.trailing])
                    }
                }
            }
            Text(model.repository?.organization ?? "")
                .font(.title3)
                .italic()
        }
    }

    private
    func getThumbnail() -> Image {
        guard let thumbnail = model.thumbnail else {
            return Image(systemName: "heart")
        }
        return Image(uiImage: thumbnail)
    }
}

#if DEBUG
import Combine

#Preview {
    let mockRepo = Repository.mock()
    let publisher = Just(mockRepo)
        .setFailureType(to: CustomError.self)
        .eraseToAnyPublisher()
    let modelInput = RepositoryCardModel
        .Input(repository: publisher, fetchImage: { _ in
            Just(Photo.star)
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        })
    let modelOutput = RepositoryCardModel
        .Output()
    let model = RepositoryCardModel(with: modelInput,
                                    and: modelOutput)
    RepositoryCard(with: model)
}
#endif
