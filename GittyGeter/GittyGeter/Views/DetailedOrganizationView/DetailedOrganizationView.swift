//
//  DetailedOrganizationView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import SwiftUI
import Kingfisher

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
                    HStack(alignment: .center) {
                        Image(systemName: "envelope")
                            .font(.subheadline)
                            .foregroundStyle(.background)
                        if let email = model.input.organization.email,
                           let url = URL(string: "mailto:\(email)") {
                            Link(email, destination: url)
                                .font(.subheadline)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                        } else {
                            Text(model.input.organization.email ?? "N/A")
                                .font(.subheadline)
                                .foregroundStyle(.background)
                                .minimumScaleFactor(0.5)
                        }

                    }
                HStack(alignment: .center) {
                    Image(systemName: "link")
                        .font(.subheadline)
                        .foregroundStyle(.background)
                    if let website = model.input.organization.websiteUrl,
                       let url = URL(string: website) {
                        Link(website, destination: url)
                            .font(.subheadline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                    } else {
                        Text(model.input.organization.websiteUrl ?? "N/A")
                            .font(.subheadline)
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(.background)
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
        .accessibilityElement(children: .contain)
        .accessibilityLabel(TestingIdentifiers.decorationView)
    }

    var repositories: some View {
        VStack(alignment: .leading) {
            if model.repositories.count > 0 {
                Text("Repositories")
                    .font(.title2)
                RepositoriesListView(with: model.makeRepositoriesListViewModel())
            }
        }
    }
}

extension DetailedOrganizationView {
    struct TestingIdentifiers {
        static let decorationView = "DetailedOrganizationView.DecorationView"
    }
}

#if DEBUG && !TESTING
import Combine

#Preview {
    let database = MockDatabase()
    let modelInput = DetailedOrganizationViewModel
        .Input(organization: Organization.mock(),
               fetcher: MockFetcher(),
               configuration: Configuration.standard(),
               getRepositories: database.getRepositories(for:sortingOrder:),
               updateFavoriteStatus: database.updateFavoriteStatus(of:to:))
    let modelOutput = DetailedOrganizationViewModel
        .Output(userSelectedRepository: PassthroughSubject(), backButtonTapped: PassthroughSubject())
    let model = DetailedOrganizationViewModel(with: modelInput, and: modelOutput)
    DetailedOrganizationView(with: model)
}
#endif
