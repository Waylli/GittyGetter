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
    @Published var queriedRepositories = Repositories()
    @Published var currentFilteredOrganizations = Organizations()
    @Published private var allOrganizations = Organizations()
    var availableOrganizations: Organizations {allOrganizations.filter {!currentFilteredOrganizations.contains($0)}}
    private var cancelBag = CancelBag()

    let input: Input
    let output: Output
    private let actions: Actions

    init(with input: Input,
         and output: Output,
         actions: Actions = Actions()) {
        self.input = input
        self.output = output
        self.actions = actions
        bind()
        bindSearch()
        bindActions()
    }

}

extension RepositoriesViewModel {

    struct Input {
        let getAllOrganizations: () -> AnyPublisher<Organizations, CustomError>
        /// params: query string, filtered organizations if array is empty repos from all orgs will be shown
        let getRepositories: (String, Organizations) -> AnyPublisher<Repositories, CustomError>
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {
        let userSelectedRepository: PassthroughSubject<Repository, Never>
    }

    struct Actions {
        let removeFilteredOrganization: PassthroughSubject<Organization, Never>
        let removeAllFilteredOrganizations: PassthroughSubject<Void, Never>
        let applyFilterToOrganization: PassthroughSubject<Organization, Never>

        init(removeFilteredOrganization: PassthroughSubject<Organization, Never> = PassthroughSubject(),
             removeAllFilteredOrganizations: PassthroughSubject<Void, Never> = PassthroughSubject(),
             applyFilterToOrganization: PassthroughSubject<Organization, Never> = PassthroughSubject()) {
            self.removeFilteredOrganization = removeFilteredOrganization
            self.removeAllFilteredOrganizations = removeAllFilteredOrganizations
            self.applyFilterToOrganization = applyFilterToOrganization
        }
    }

    func makeFilterOrganizationsComponentModel() -> FilterOrganizationsComponentModel {
        let modelInput = FilterOrganizationsComponentModel
            .Input(availableOrganizations: availableOrganizations,
                   currentFilteredOrganizations: currentFilteredOrganizations,
                   configuration: input.configuration)
        let modelOutput = FilterOrganizationsComponentModel
            .Output(removeFilteredOrganization: actions.removeFilteredOrganization,
                    removeAllFilteredOrganizations: actions.removeAllFilteredOrganizations,
                    applyFilterFromOrganization: actions.applyFilterToOrganization)
        return FilterOrganizationsComponentModel(with: modelInput,
                                                 and: modelOutput)
    }

    func makeRepositoriesListViewModel() -> RepositoriesListViewModel {
        let modelInput = RepositoriesListViewModel
            .Input(isScrollable: true,
                   repositories: queriedRepositories,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = RepositoriesListViewModel
            .Output(userSelectedRepository: output.userSelectedRepository)
        return RepositoriesListViewModel(with: modelInput, and: modelOutput)
    }
}

private
extension RepositoriesViewModel {

    func bind() {
        input.getAllOrganizations()
            .sink(receiveCompletion: { _ in
                print("handle erro if any")
            }, receiveValue: { [weak self] in
                self?.allOrganizations = $0
            })
            .store(in: &cancelBag)
    }

    func bindSearch() {
        Publishers
            .CombineLatest($query.throttle(for: 0.2, scheduler: RunLoop.main, latest: true), $currentFilteredOrganizations)
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
                self?.queriedRepositories = $0
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
