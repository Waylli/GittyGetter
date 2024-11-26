//
//  Repository.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

struct Repository: Codable, Identifiable {

    let id: String
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
    }

}

#if DEBUG
extension Repository {
    static func mock() -> Repository {
        Repository(id: UUID().uuidString,
                   name: "some name",
                   fullName: "some full name",
                   description: "some description and type some more text to have it be as long as possible \(UUID().uuidString) + \(UUID().uuidString)",
                   language: "Swift",
                   stargazersCount: 10,
                   forksCount: 2)
    }
}
#endif
