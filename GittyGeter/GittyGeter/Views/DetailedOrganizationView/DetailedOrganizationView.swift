//
//  DetailedOrganizationView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI

struct DetailedOrganizationView: View {

    @ObservedObject private var model: DetailedOrganizationViewModel

    init(with model: DetailedOrganizationViewModel) {
        self.model = model
    }

    var body: some View {
        VStack {
            HStack {
                Button {
                    model.backButtonTapped()
                } label: {
                    BackNavigationComponenet(configuration: model.input.configuration)
                }
                .foregroundStyle(.primary)
                Spacer()
            }
            TitleTextComponent(title: model.input.organization.name)
            DescriptionTextComponent(text: model.input.organization.description)
            decoration
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius)
                        .foregroundStyle(.primary)

                }
            repositories
            Spacer()
        }
        .padding()
    }

    var decoration: some View {
        HStack(alignment: .top) {
            ZStack {
                if let photo = model.orgThumbnail {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: model.input.configuration.view.cornerRadius))
                }
            }
            .frame(width: 100, height: 100)
            VStack(alignment: .leading, spacing: 16) {
                if let email = model.input.organization.email,
                    let url = URL(string: "mailto:\(email)") {
                    HStack(alignment: .center) {
                        Image(systemName: "envelope")
                            .font(.subheadline)
                            .foregroundStyle(.background)
                        Link(email, destination: url)
                            .font(.subheadline)

                    }
                }
                if let website = model.input.organization.websiteUrl,
                   let url = URL(string: website) {
                    HStack(alignment: .center) {
                        Image(systemName: "link")
                            .font(.subheadline)
                            .foregroundStyle(.background)
                        Link(website, destination: url)
                            .font(.subheadline)
                    }
                }
                HStack(alignment: .center) {
                    Image(systemName: "figure.wave")
                        .font(.subheadline)
                        .foregroundStyle(.background)
                    Text(" \(model.input.organization.followers)")
                        .font(.subheadline)
                        .foregroundStyle(.background)
                }
            }
            Spacer()
        }
    }

    var repositories: some View {
        VStack(alignment: .leading) {
            if !model.repositories.isEmpty {
                Text("Repositories")
                    .font(.title2)
                RepositoriesListView(with: model.makeRepositoriesListViewModel())
            }
        }
    }
}

#if DEBUG
import Combine

#Preview {
    let modelInput = DetailedOrganizationViewModel
        .Input(organization: .mock(),
               fetcher: MockFetcher(),
               configuration: Configuration.standard()) { _ in
            Just(Repository.mocks())
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        }
    let modelOutput = DetailedOrganizationViewModel
        .Output(userSelectedRepository: PassthroughSubject(), backButtonTapped: PassthroughSubject())
    let model = DetailedOrganizationViewModel(with: modelInput, and: modelOutput)
    DetailedOrganizationView(with: model)
}
#endif
