//
//  AppManager.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation

class AppManager {

    let model: AppManagerModel

    init(with model: AppManagerModel) {
        self.model = model
        start()
    }

}

private
extension AppManager {
    func start() {
        let viewModel = model.viewModelFactor.makeGittyTabViewModel(with: GittyTabViewModel.Output())
        let entryView = GittyTabView(with: viewModel)
        self.model.navigator.set(views: [entryView.toViewController()], animated: true)
    }
}
