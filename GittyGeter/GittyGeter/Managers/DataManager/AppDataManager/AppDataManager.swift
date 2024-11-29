//
//  AppDataManager.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Combine

class AppDataManager {

    let model: AppDataManagerModel
    var whenTheDataWasLastRefreshed: Date?

    init(with model: AppDataManagerModel) {
        self.model = model
    }

}

extension AppDataManager: DataManager {

    func refreshContent() -> AnyPublisher<Success, CustomError> {
        <#code#>
    }
    
    func add(this organization: Organization) -> AnyPublisher<Success, CustomError> {
        fatalError("not implemented")
    }
    
    func remove(this organization: Organization) -> AnyPublisher<Success, CustomError> {
        fatalError("not implemented")
    }
    
    func getOrganizations() -> AnyPublisher<Organizations, CustomError> {
        model.input.localDatabase.getOrganizations()
    }
    
    func getRepositories(query: String, within organizations: Organizations) -> AnyPublisher<Repositories, CustomError> {
        model.input.localDatabase.getRepositories(query: query, within: organizations)
    }
    
    func getFavouriteRepositories() -> AnyPublisher<Repositories, CustomError> {
        model.input.localDatabase.getFavouriteRepositories()
    }
    
    func getRepositories(for organization: Organization) -> AnyPublisher<Repositories, CustomError> {
        model.input.localDatabase.getRepositories(for: organization)
    }

}
