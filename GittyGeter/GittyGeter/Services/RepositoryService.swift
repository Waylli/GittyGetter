//
//  RepositoryService.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import Combine

protocol RepositoryService {

    func getFavoriteOrganizations() -> AnyPublisher<[Organization], Never>
    func getRepositories(for organization: Organization) -> AnyPublisher<[Repository], CustomError>

}
