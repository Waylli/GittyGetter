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
                    Text(model.input.repository.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(model.input.repository.description ?? "")
                        .fontWeight(.light)
                        .italic()
                        .font(.headline)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                    HStack {
                        HStack(alignment: .bottom, spacing: 4) {
                            Image(uiImage: UIImage.star)
                            Text("\(model.input.repository.stargazersCount)")
                                .fontWeight(.light)
                                .italic()
                                .font(.headline)
                        }
                        Spacer()
                        HStack (alignment: .bottom, spacing: 4) {
                            Image(uiImage: UIImage.fork)
                            Text("\(model.input.repository.forksCount)")
                                .fontWeight(.light)
                                .italic()
                                .font(.headline)
                        }
                        .padding([.trailing])
                    }
                }
            }
            Text(model.input.repository.organization)
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
    let modelInput = RepositoryCardModel
        .Input(repository: mockRepo, fetchImage: { _ in
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
