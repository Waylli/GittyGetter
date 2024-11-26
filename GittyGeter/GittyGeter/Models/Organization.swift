//
//  Organization.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

struct Organization: Codable, Identifiable {
    let identifier: String
    let avatarURL: URL

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case avatarURL = "avatar_url"
    }
}

extension Organization {

    var id: String {identifier}

    init(identifier: String, avatarUrl: String) throws {
        guard let url = URL(string: avatarUrl) else {
            throw CustomError.dataMappingFailed
        }
        self.identifier = identifier
        self.avatarURL = url
    }
}

