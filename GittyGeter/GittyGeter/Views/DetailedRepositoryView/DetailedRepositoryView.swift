//
//  DetailedRepositoryView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI

struct DetailedRepositoryView: View {

    @ObservedObject private var model: DetailedRepositoryViewModel

    init(with model: DetailedRepositoryViewModel) {
        self.model = model
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            backView
            Group {
                TitleTextComponent(title: model.input.repository.name.capitalized)
                DescriptionTextComponent(text: model.input.repository.description)
            }
            VStack(spacing: 16) {
                if let photo = model.avatar {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: model.input.configuration.thumbnail.widht, height: model.input.configuration.thumbnail.height)
                        .clipShape(RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius))
                }
                getCodingLanguageView()
                getOwnerView()
                repositoryInfoView
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius)
                            .foregroundStyle(.primary.opacity(0.15))
                    }
            }
            .padding([.top, .bottom])

            Spacer()
        }
        .padding()
    }

    private
    var backView: some View {
        HStack {
            Button {
                model.backButtonTapped()
            } label: {
                BackNavigationComponenet(configuration: model.input.configuration)
            }
            .foregroundStyle(.primary)
            Spacer()
        }
        .overlay {
            HStack {
                Spacer()
                Image(systemName: model.isFavouriteRepository ? "heart.fill" : "heart")
                    .font(.largeTitle)
                    .padding()
                    .foregroundStyle(.orange)
                    .onTapGesture {
                        model.isFavouriteRepository.toggle()
                    }
            }
        }
    }

    private
    func getCodingLanguageView() -> some View {
        guard let language = model.input
            .repository.language else {
            return AnyView(EmptyView())
        }
        return AnyView(
            HStack {
                Image(systemName: "chevron.left.slash.chevron.right")
                    .font(.headline)
                Text(language)
                    .font(.headline)
                    .bold()
            }
        )
    }

    private
    func getOwnerView() -> some View {
        HStack {
            Image(systemName: "building.2")
                .font(.headline)
            Text("by: \(model.input.repository.organization)")
                .font(.headline)
        }
    }

    private var repositoryInfoView: some View {
        HStack {
            VStack(spacing: 16) {
                getInfoBlock(for: "\(model.input.repository.stargazersCount)",
                             and: "Stargazers")
                getInfoBlock(for: "\(Date())",
                             and: "Created at")
                getInfoBlock(for: "\(model.input.repository.watchers)",
                             and: "Watchers")
            }
            .frame(maxWidth: .infinity)
            .background(model.input.configuration.colors.tappableClearColor)
            VStack(spacing: 16) {
                getInfoBlock(for: "\(model.input.repository.forksCount)",
                             and: "forks")
                getInfoBlock(for: "11mb",
                             and: "Size")
                getInfoBlock(for: "\(model.input.repository.issues)",
                             and: "Issues")
            }
            .frame(maxWidth: .infinity)
            .background(model.input.configuration.colors.tappableClearColor)
        }
        .overlay {
            HStack {
                Spacer()
                Color.primary
                    .frame(width: 1)
                Spacer()
            }
        }
    }

    private func getInfoBlock(for title: String,
                              and subtitle: String) -> some View {
        VStack {
            Text(title)
                .font(.title2)
            Text(subtitle)
                .font(.title3)
        }
    }
}

#if DEBUG
import Combine

#Preview {
    let modelInput = DetailedRepositoryViewModel
        .Input(repository: Repository.mock(),
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = DetailedRepositoryViewModel
        .Output(backButtonTapped: PassthroughSubject())
    let model = DetailedRepositoryViewModel(with: modelInput,
                                            and: modelOutput)
    DetailedRepositoryView(with: model)
}
#endif
