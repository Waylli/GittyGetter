//
//  Organization.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

struct Organization: Codable, Identifiable {
    let identifier: String
    let avatarURL: URL?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case avatarURL = "avatar_url"
    }
}

extension Organization {

    var id: String {identifier}

    init(identifier: String, avatarUrl: String) {
        self.identifier = identifier
        self.avatarURL = URL(string: identifier)
    }

}

#if DEBUG
extension Organization {

    static
    func mock() -> Organization {
        Organization(identifier: UUID().uuidString, avatarURL: nil)
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

