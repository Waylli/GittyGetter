//
//  Repository.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

extension Repository {

    struct Owner: Codable {
        let name: String?
        let login: String?
        let avatarUrl: String?

        enum CodingKeys: String, CodingKey {
            case name
            case login
            case avatarUrl = "avatar_url"
        }
    }
}

struct Repository: Identifiable, Hashable, Codable {
    let identifier: String
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
    let organizationName: String
    let size: Int
    let isFavourite: Bool

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case description
        case language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks"
        case watchers = "watchers_count"
        case issues = "open_issues_count"
        case avatarURL = "owner.avatar_url"
        case organizationName = "owner"
        case size
    }

    // Custom decoding to handle `identifier` as a String while the JSON contains a number
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idInt = try container.decode(Int.self, forKey: .identifier)
        identifier = String(idInt)
        name = try container.decode(String.self, forKey: .name)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        stargazersCount = try container.decodeIfPresent(Int.self, forKey: .stargazersCount) ?? 0
        forksCount = try container.decodeIfPresent(Int.self, forKey: .forksCount) ?? 0
        watchers = try container.decodeIfPresent(Int.self, forKey: .watchers) ?? 0
        issues = try container.decodeIfPresent(Int.self, forKey: .issues) ?? 0
        size = try container.decode(Int.self, forKey: .size)
        //        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)

        // Decode nested owner object
        let ownerContainer = try container
            .nestedContainer(keyedBy: Owner.CodingKeys.self, forKey: .organizationName)
        organizationName = try ownerContainer
            .decodeIfPresent(String.self,
                             forKey: Repository.Owner.CodingKeys.name) ?? ownerContainer
            .decodeIfPresent(String.self,
                             forKey: Repository.Owner.CodingKeys.login) ?? ""
        avatarURL = try ownerContainer.decodeIfPresent(String.self, forKey: .avatarUrl)
        isFavourite = false // Not decoded from JSON, used internally
    }

    init(identifier: String,
         name: String,
         createdAt: Date?,
         updatedAt: Date?,
         description: String?,
         language: String?,
         stargazersCount: Int,
         forksCount: Int,
         watchers: Int,
         issues: Int,
         avatarURL: String?,
         organizationName: String,
         isFavourite: Bool) {
        self.identifier = identifier
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.description = description
        self.language = language
        self.stargazersCount = stargazersCount
        self.forksCount = forksCount
        self.watchers = watchers
        self.issues = issues
        self.avatarURL = avatarURL
        self.organizationName = organizationName
        self.isFavourite = isFavourite
        size = Int.random(in: 1000...100000)
    }

}

extension Repository {
    var id: String {identifier}
}

#if DEBUG
extension Repository {
    static func mock(isFavorite: Bool = Int.random(in: 0...4) == 0) -> Repository {
        Repository(identifier: UUID().uuidString,
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
                   organizationName: "Algorand Foundation",
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
