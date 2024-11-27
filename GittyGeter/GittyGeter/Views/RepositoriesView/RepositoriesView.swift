//
//  RepositoriesView.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import SwiftUI

struct RepositoriesView: View {

    @ObservedObject private var model: RepositoriesViewModel

    init(with model: RepositoriesViewModel) {
        self.model = model
    }

    var body: some View {
        VStack {
                TitleTextComponent(title: "Repositories")
                searchView
                FilterOrganizationsComponent(with: model.createFilterOrganizationsComponentModel())
            RepositoriesListView(with: model.createRepositoriesListViewModel())
            Spacer()
        }
        .padding()
        .animation(.easeIn(duration: 0.1), value: model.currentFilteredOrganizations)
    }

    private
    var searchView: some View {
        TextField(text: $model.query) {
            Text("🔍 search")
        }
        .textFieldStyle(.roundedBorder)
    }

}

#if DEBUG
import Combine
#Preview {
    let orgs = Just(Organization.mocks()).eraseToAnyPublisher()
    let modelInput = RepositoriesViewModel
        .Input(oragnizations: orgs, getRepositories: { _, _ in
            Just(Repository.mocks())
                .setFailureType(to: CustomError.self)
                .eraseToAnyPublisher()
        },
               fetcher: MockFetcher(),
               configuration: Configuration.standard())
    let modelOutput = RepositoriesViewModel
        .Output()
    let model = RepositoriesViewModel(with: modelInput, and: modelOutput)
    RepositoriesView(with: model)
}
#endif

struct WrappingItemsView: View {
    let items: [String]

    var body: some View {
        FlowLayout(items: items) { item in
            Text(item)
                .padding(8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .background(Color.gray.opacity(0.2)) // Optional background for visibility
    }
}

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    private let items: Data
    private let content: (Data.Element) -> Content

    init(items: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.items = items
        self.content = content
    }

    @State private var totalHeight: CGFloat = 0

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry.size)
            }
        }
        .frame(height: totalHeight) // Adjust height to fit content
    }

    private func generateContent(in size: CGSize) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                self.content(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        width -= d.width
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        return result
                    }
            }
        }
        .background(HeightReader(totalHeight: $totalHeight)) // Measure height
    }
}

struct HeightReader: View {
    @Binding var totalHeight: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    self.totalHeight = geometry.size.height
                }
                .onChange(of: geometry.size.height) { newHeight in
                    self.totalHeight = newHeight
                }
        }
    }
}
