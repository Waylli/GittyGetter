//
//  OrganizationsViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation
import Combine

class OrganizationsViewModel: ObservableObject {

    @Published private(set) var organizations = Organizations()
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

extension OrganizationsViewModel {

    struct Input {
        let oragnizations: AnyPublisher<Organizations, Never>
        let fetcher: Fetcher
        let configuration: Configuration
    }

    struct Output {
        let userSelectedOrganization: PassthroughSubject<Organization, Never>
    }

    func makeOrganizationsListModel() -> OrganizationsListModel {
        let modelInput = OrganizationsListModel
            .Input(organizations: organizations,
                   fetcher: input.fetcher,
                   configuration: input.configuration)
        let modelOutput = OrganizationsListModel
            .Output(userSelectedOrganization: output.userSelectedOrganization)
        return OrganizationsListModel(with: modelInput, and: modelOutput)
    }

    func userSelected(this organization: Organization) {
        output.userSelectedOrganization.send(organization)
    }

}

private
extension OrganizationsViewModel {

    func bind() {
        input.oragnizations
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.organizations = $0
            }
            .store(in: &cancelBag)
    }
}
