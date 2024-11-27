//
//  RepositoriesViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import Combine

class RepositoriesViewModel: ObservableObject {

    @Published var query = ""
    @Published var quriedRepositories = Repositories()
    @Published var currentFilteredOrganizations = Organizations()
    @Published private var allOrganizations = Organizations()
    private var cancelBag = CancelBag()

    let input: Input
    let output: Output
    private let actions = Actions()

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
        bind()
        bindSearch()
        bindActions()
    }

    func createRepositoriesListViewModel() -> RepositoriesListViewModel {
        let modelInput = RepositoriesListViewModel
            .Input(isScrollable: true,
                   repositories: quriedRepositories,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = RepositoriesListViewModel
            .Output()
        return RepositoriesListViewModel(with: modelInput, and: modelOutput)
    }
}

extension RepositoriesViewModel {

    struct Input {
        let allOrganizations: AnyPublisher<Organizations, Never>
        /// params: query string, filtered organizations if array is empty repos from all orgs will be shown
        let getRepositories: (String, Organizations) -> AnyPublisher<Repositories, CustomError>
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {

    }

    struct Actions {
        let removeFilteredOrganization = PassthroughSubject<Organization, Never>()
        let removeAllFilteredOrganizations = PassthroughSubject<Void, Never>()
        let applyFilterToOrganization = PassthroughSubject<Organization, Never>()
    }

    func createFilterOrganizationsComponentModel() -> FilterOrganizationsComponentModel {
        let available = allOrganizations.filter {!currentFilteredOrganizations.contains($0)}
        // improve after tesing
        let modelInput = FilterOrganizationsComponentModel
            .Input(availableOrganizations: available,
                   currentFilteredOrganizations: currentFilteredOrganizations,
                   configuration: input.configuration)
        let modelOutput = FilterOrganizationsComponentModel
            .Output(removeFilteredOrganization: actions.removeFilteredOrganization,
                    removeAllFilteredOrganizations: actions.removeAllFilteredOrganizations,
                    applyFilterFromOrganization: actions.applyFilterToOrganization)
        return FilterOrganizationsComponentModel(with: modelInput,
                                                 and: modelOutput)
    }
}

private
extension RepositoriesViewModel {

    func bind() {
        input.allOrganizations
            .sink { [weak self] in
                self?.allOrganizations = $0
            }
            .store(in: &cancelBag)
    }

    func bindSearch() {
        Publishers
            .CombineLatest($query.throttle(for: 2, scheduler: RunLoop.main, latest: true), $currentFilteredOrganizations)
            .flatMap { [weak self] (query, organizations) -> AnyPublisher<Repositories, Never> in
                guard let this = self else {return Empty().eraseToAnyPublisher()}
                return this.input.getRepositories(query, organizations)
                    .mapError { error -> CustomError in
                        this.handle(this: error)
                        return error
                    }
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.quriedRepositories = $0
            }
            .store(in: &cancelBag)
    }

    func handle(this error: CustomError) {

    }

    private func bindActions() {
        actions
            .applyFilterToOrganization
            .sink { [weak self] in
                guard let this = self, this.currentFilteredOrganizations.firstIndex(of: $0) == nil else {
                    return
                }
                this.currentFilteredOrganizations.append($0)
            }
            .store(in: &cancelBag)
        actions
            .removeFilteredOrganization
            .sink { [weak self] in
                self?.currentFilteredOrganizations.removeSafe($0)
            }
            .store(in: &cancelBag)
        actions
            .removeAllFilteredOrganizations
            .sink { [weak self] _ in
                self?.currentFilteredOrganizations.removeAll()
            }
            .store(in: &cancelBag)
    }

}
