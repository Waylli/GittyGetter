//
//  NetworkService.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Combine

protocol NetworkService {
    func fetchOrganizationWith(login: String) -> AnyPublisher<Organization, CustomError>
    func fetchRepositoriesForOrganizationWith(login: String) -> AnyPublisher<Repositories, CustomError>
}
