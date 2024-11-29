//
//  GitHubService.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation

import Moya

// Define the endpoints for the GitHub API
enum GitHubService {
    case fetchRepositoriesForOrganizationWith(login: String)
    case fetchOrganizationWith(login: String)
}

extension GitHubService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .fetchRepositoriesForOrganizationWith(let organization):
            return "/orgs/\(organization)/repos"
        case .fetchOrganizationWith(let login):
            return "/orgs/\(login)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchRepositoriesForOrganizationWith, .fetchOrganizationWith:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .fetchRepositoriesForOrganizationWith, .fetchOrganizationWith:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let token = GitHubService.authToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }

    var sampleData: Data {
        switch self {
        case  .fetchRepositoriesForOrganizationWith, .fetchOrganizationWith:
            return Data() // You can add sample JSON data here for testing
        }
    }

    static var authToken: String? = nil
}
