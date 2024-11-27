//
//  AppManager.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation

class AppManager {

    let model: AppManagerModel
    private var cancelBag = CancelBag()

    init(with model: AppManagerModel) {
        self.model = model
        bindActions()
        start()
    }

}

private
extension AppManager {
    func start() {
        let modelOutput = GittyTabViewModel.Output(userSelectedRepository: model.actions.userSelectedRepository,
                                                   userSelectedOrganization: model.actions.userSelectedOrganization)
        let viewModel = model.viewModelFactor.makeGittyTabViewModel(with: modelOutput)
        let entryView = GittyTabView(with: viewModel)
        self.model.navigator.set(views: [entryView.toViewController()], animated: true)
    }

    func bindActions() {
        model.actions
            .userSelectedRepository
            .sink { [weak self] repository in
                self?.showDetail(for: repository)
            }
            .store(in: &cancelBag)
        model.actions
            .userSelectedOrganization
            .sink { [weak self] organization in
                self?.showDetail(for: organization)
            }
            .store(in: &cancelBag)
        model.actions
            .backButtonTapped
            .sink { [weak self] _ in
                self?.model.navigator.pop(animated: true)
            }
            .store(in: &cancelBag)
    }
}

private
extension AppManager {

    func showDetail(for repository: Repository) {
        let modelOutput = DetailedRepositoryViewModel
            .Output(backButtonTapped: model.actions.backButtonTapped)
        let repoDetailView = model.viewModelFactor.makeDetailModel(for: repository, modelOutput: modelOutput)
        let detailedRepositoryView = DetailedRepositoryView(with: repoDetailView)
        model.navigator.push(view: detailedRepositoryView.toViewController(),
                             animated: true)
    }

    func showDetail(for organization: Organization) {
        let modelOutput = DetailedOrganizationViewModel
            .Output(userSelectedRepository: model.actions.userSelectedRepository,
                    backButtonTapped: model.actions.backButtonTapped)
        let viewModel = model.viewModelFactor
            .makeDetailedOrganizationViewModel(for: organization, modelOutput: modelOutput)
        let view = DetailedOrganizationView(with: viewModel)
        model.input.navigationCoordinator.push(view: view.toViewController(), animated: true)
    }

}
