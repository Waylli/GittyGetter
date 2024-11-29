//
//  Repository.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

struct Repository: Identifiable, Hashable {

    let id: String
    let name: String
    let createdAt: Date?
    let updatedAt: Date?
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let watchers: Int
    let issues: Int
    let avatarURL: String?
    let organization: String
    let isFavourite: Bool

    var identifier: String {id}
}

#if DEBUG
extension Repository {
    static func mock(isFavorite: Bool = Int.random(in: 0...4) == 0) -> Repository {
        Repository(id: UUID().uuidString,
                   name: "some name \(UUID().uuidString)",
                   createdAt: Date() - 10000,
                   updatedAt: Date(),
                   description: "some description and type some more text to have it be as long as possible \(UUID().uuidString) + \(UUID().uuidString)",
                   language: "Swift",
                   stargazersCount: 10,
                   forksCount: 2,
                   watchers: Int.random(in: 1...100),
                   issues: Int.random(in: 1...20),
                   avatarURL: "https://avatars.githubusercontent.com/u/49564161?v=4",
                   organization: "Algorand Foundation",
                   isFavourite: isFavorite)
    }

    static func mocks(count: Int = 10,
                      isFavorite: Bool = Int.random(in: 0...4) == 1) -> Repositories {
        guard count > 0, count < 1000 else {
            return []
        }
        var repos = Repositories()
        for _ in 1...count {
            let repo = Repository.mock(isFavorite: isFavorite)
            repos.append(repo)
        }
        return repos
    }
}
#endif
