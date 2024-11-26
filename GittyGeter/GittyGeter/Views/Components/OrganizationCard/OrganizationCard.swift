//
//  OrganizationCard.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct OrganizationCard: View {

    @ObservedObject private var model: OrganizationCardModel

    init(with model: OrganizationCardModel) {
        self.model = model
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(uiImage: UIImage.star)
                        .resizable()
                        .frame(width: model.input.configuration.thumbnail.widht,
                               height: model.input.configuration.thumbnail.height)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Org name")
                        Text("Org description")
                        Text("followers count")
                    }
                    Spacer()
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    let modelInput = OrganizationCardModel
        .Input(organization: Organization.mock(),
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = OrganizationCardModel
        .Output()
    let model = OrganizationCardModel(with: modelInput, and: modelOutput)
    OrganizationCard(with: model)
}
#endif
