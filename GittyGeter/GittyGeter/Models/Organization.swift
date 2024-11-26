//
//  Organization.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

struct Organization: Identifiable, Hashable {
    let identifier: String
    let name: String
    let descrition: String?
    let websiteUrl: String?
    let followers: Int
    let avatarURL: String?
}

extension Organization {

    var id: String {identifier}

}

#if DEBUG
extension Organization {

    static
    func mock() -> Organization {
        Organization(identifier: String.random(),
                     name: String.orgName(),
                     descrition: "some description which need to be a bit longer",
                     websiteUrl: "https://algorand.co/",
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

