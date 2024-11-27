//
//  DetailedOrganizationViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Combine

class DetailedOrganizationViewModel: ObservableObject {

    @Published var orgThumbnail: Photo?
    @Published var repositories = Repositories()
    private var cancelBag = CancelBag()

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
        bind()
    }
}

extension DetailedOrganizationViewModel {

    struct Input {
        let organization: Organization
        let fetcher: Fetcher
        let configuration: Configuration
        let getRepositories: (Organization) -> AnyPublisher<Repositories, CustomError>
    }

    struct Output {
        let userSelectedRepository: PassthroughSubject<Repository, Never>
        let backButtonTapped: PassthroughSubject<Void, Never>
    }

    func makeRepositoriesListViewModel() -> RepositoriesListViewModel {
        let modelInput = RepositoriesListViewModel
            .Input(isScrollable: true,
                   repositories: repositories,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = RepositoriesListViewModel
            .Output(userSelectedRepository: output.userSelectedRepository)
        return RepositoriesListViewModel(with: modelInput, and: modelOutput)
    }

    func backButtonTapped() {
        output.backButtonTapped.send(())
    }
}

private
extension DetailedOrganizationViewModel {
    func bind() {
        getAvatar()
        getRepositories()
    }

    func getAvatar() {
        guard let avatarUrl = input.organization.avatarURL else {
            return
        }
        input.fetcher
            .fetchPhoto(from: avatarUrl)
            .receive(on: RunLoop.main)
            .sink { _ in

            } receiveValue: { [weak self] in
                self?.orgThumbnail = $0
            }
            .store(in: &cancelBag)
    }

    func getRepositories() {
        input.getRepositories(input.organization)
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error): self?.handle(this: error)
                }
            } receiveValue: { [weak self] repositories in
                self?.repositories = repositories
            }
            .store(in: &cancelBag)
    }

    func handle(this error: Error) {

    }
}
