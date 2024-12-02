//
//  ApplicationCoordinator.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation

class ApplicationCoordinator {

    let model: ApplicationCoordinatorModel
    private var cancelBag = CancelBag()

    init(with model: ApplicationCoordinatorModel) {
        self.model = model
        bindActions()
        start()
    }

}

private
extension ApplicationCoordinator {
    func start() {
        model.input.dataManager
            .refreshContent()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                // we do not care about error
                guard let this = self else {return}
                let modelOutput = GittyTabViewModel.Output(userSelectedRepository: this.model.events.repositorySelected,
                                                           userSelectedOrganization: this.model.events.organizationSelected)
                let viewModel = this.model.viewModelFactory.makeGittyTabViewModel(with: modelOutput)
                let entryView = GittyTabView(with: viewModel)
                this.model.navigator.set(views: [entryView.toViewController()], animated: true)
            } receiveValue: { _ in
            }
            .store(in: &cancelBag)
    }

    func bindActions() {
        model.events
            .repositorySelected
            .sink { [weak self] repository in
                self?.showDetail(for: repository)
            }
            .store(in: &cancelBag)
        model.events
            .organizationSelected
            .sink { [weak self] organization in
                self?.showDetail(for: organization)
            }
            .store(in: &cancelBag)
        model.events
            .backTapped
            .sink { [weak self] _ in
                self?.model.navigator.pop(animated: true)
            }
            .store(in: &cancelBag)
    }
}

private
extension ApplicationCoordinator {

    func showDetail(for repository: Repository) {
        let modelOutput = DetailedRepositoryViewModel
            .Output(backButtonTapped: model.events.backTapped)
        let repoDetailView = model.viewModelFactory.makeDetailedRepositoryViewModel(for: repository, modelOutput: modelOutput)
        let detailedRepositoryView = DetailedRepositoryView(with: repoDetailView)
        model.navigator.push(view: detailedRepositoryView.toViewController(),
                             animated: true)
    }

    func showDetail(for organization: Organization) {
        let modelOutput = DetailedOrganizationViewModel
            .Output(userSelectedRepository: model.events.repositorySelected,
                    backButtonTapped: model.events.backTapped)
        let viewModel = model.viewModelFactory
            .makeDetailedOrganizationViewModel(for: organization, modelOutput: modelOutput)
        let view = DetailedOrganizationView(with: viewModel)
        model.input.navigationCoordinator.push(view: view.toViewController(), animated: true)
    }

}
