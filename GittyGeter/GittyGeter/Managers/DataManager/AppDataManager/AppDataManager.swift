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
    static let hardcodedOrganizationLogins = ["perawallet",
                                              "algorandfoundation",
                                              "algorand"]
    private var cancelBag = CancelBag()

    init(with model: AppDataManagerModel) {
        self.model = model
        // error not handled
        model.input.localDatabase
            .initialize()
            .sink { _ in } receiveValue: { _ in  }
            .store(in: &cancelBag)

    }

}

extension AppDataManager: DataManager {

    func refreshContent() -> AnyPublisher<Success, CustomError> {
        localRefresh()
    }

    func addOrganizationWith(_ identifier: String) -> AnyPublisher<Success, CustomError> {
        Publishers.CombineLatest(model.input.networkService.fetchOrganizationWith(login: identifier), model.input.networkService.fetchRepositoriesForOrganizationWith(login: identifier))
            .flatMap { [weak self] (org, repos) -> AnyPublisher<Success, CustomError> in
                guard let this = self else {return Fail(error: CustomError.objectNotFound).eraseToAnyPublisher()}
                return this.model.input.localDatabase.storeOrUpdate(repositories: repos, parentOrganization: org)
            }
            .eraseToAnyPublisher()
    }

    func remove(this organization: Organization) -> AnyPublisher<Success, CustomError> {
        guard organization.canBeRemoved else { return Fail(error: CustomError.dataMappingFailed).eraseToAnyPublisher() }
        return model.input.localDatabase
            .delete(organization: organization)
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

    func updateFavoriteStatus(of repository: Repository, to newStatus: Bool) -> AnyPublisher<Success, CustomError> {
        model.input.localDatabase.updateFavoriteStatus(of: repository, to: newStatus)
    }
}


private
extension AppDataManager {

    func localRefresh() -> AnyPublisher<Success, CustomError> {
        return getOrganizationIdentifiers()
            .flatMap(maxPublishers: .max(5)) {[weak self] identifiers -> AnyPublisher<String, CustomError> in
                guard let this = self else {return Fail(error: CustomError.objectNotFound).eraseToAnyPublisher()}
                return this.getFinalLogins(from: identifiers) }
            .flatMap { self.fetchOrganization(login: $0) }
            .flatMap { self.fetchRepositories(organization: $0) }
            .flatMap { self.storeRepositoriesAndOrganization(organization: $0.0, repositories: $0.1) }
            .collect()
            .map {!$0.contains(false)}
            .eraseToAnyPublisher()
    }

    private func getOrganizationIdentifiers() -> AnyPublisher<[String], CustomError> {
        model.input.localDatabase.getOrganizations()
            .map { $0.map { $0.identifier } }
            .eraseToAnyPublisher()
    }

    private func getFinalLogins(from identifiers: [String]) -> AnyPublisher<String, CustomError> {
        let finalLogins = identifiers.count < Self.hardcodedOrganizationLogins.count ? Self.hardcodedOrganizationLogins : identifiers
        return finalLogins.publisher
            .setFailureType(to: CustomError.self)
            .eraseToAnyPublisher()
    }

    private func fetchOrganization(login: String) -> AnyPublisher<Organization, CustomError> {
        model.input.networkService.fetchOrganizationWith(login: login)
    }

    private func fetchRepositories(organization: Organization) -> AnyPublisher<(Organization, Repositories), CustomError> {
        return self.model.input.networkService
            .fetchRepositoriesForOrganizationWith(login: organization.identifier)
            .map {(organization, $0)}
            .eraseToAnyPublisher()
    }

    private func storeRepositoriesAndOrganization(organization: Organization, repositories: Repositories) -> AnyPublisher<Success, CustomError> {
        model.input.localDatabase.storeOrUpdate(repositories: repositories, parentOrganization: organization)
    }

}
