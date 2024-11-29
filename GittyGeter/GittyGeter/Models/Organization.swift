//
//  Organization.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

struct Organization: Identifiable, Hashable, Codable {

    let identifier: String
    let createdAt: Date?
    let updatedAt: Date?
    let name: String
    let description: String?
    let websiteUrl: String?
    let email: String?
    let followers: Int
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name = "login"
        case description
        case websiteUrl = "websiteUrl"
        case email
        case followers = "followers"
        case avatarURL = "avatar_url"
    }

    init(identifier: String,
         createdAt: Date?,
         updatedAt: Date?,
         name: String,
         description: String?,
         websiteUrl: String?,
         email: String?,
         followers: Int,
         avatarURL: String?) {
        self.identifier = identifier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        self.description = description
        self.websiteUrl = websiteUrl
        self.email = email
        self.followers = followers
        self.avatarURL = avatarURL
    }

    init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           let idInt = try container.decode(Int.self, forKey: .identifier)
           identifier = String(idInt)
           createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
           updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
           name = try container.decode(String.self, forKey: .name)
           description = try container.decodeIfPresent(String.self, forKey: .description)
           websiteUrl = try container.decodeIfPresent(String.self, forKey: .websiteUrl)
           email = try container.decodeIfPresent(String.self, forKey: .email)
           followers = try container.decodeIfPresent(Int.self, forKey: .followers) ?? 0
           avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
       }
}

extension Organization {
    var id: String {identifier}
}

#if DEBUG
extension Organization {

    static
    func mock() -> Organization {
        Organization(identifier: String.random(),
                     createdAt: Date() - 1000000,
                     updatedAt: Date() - 100,
                     name: String.random(),
                     description: "some description which need to be a bit longer",
                     websiteUrl: "https://algorand.co/",
                     email: "some@some.com",
                     followers: Int.random(in: 100...1000),
                     avatarURL: "https://avatars.githubusercontent.com/u/49564161?v=4")
    }

    static func mocks(count: Int = 10) -> Organizations {
        guard count > 0 && count < 100 else {
            return []
        }
        var organizations = Organizations()
        for _ in 1...count {
            organizations.append(Organization.mock())
        }
        return organizations
    }
}
#endif
