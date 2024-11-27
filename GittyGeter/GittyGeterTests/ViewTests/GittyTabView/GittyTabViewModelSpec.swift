//
//  GittyTabViewModelSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 27/11/2024.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import GittyGeter

class GittyTabViewModelSpec: QuickSpec {

    override class func spec() {
        describe("GittyTabViewModel") {
            var model: GittyTabViewModel!

            beforeEach {
                model = Self.makeGittyTabViewModel(all: Organization.mocks(), getRepositories: { _, _ in
                    Just(Repository.mocks())
                        .setFailureType(to: CustomError.self)
                        .eraseToAnyPublisher()
                })
            }

            afterEach {
                model = nil
            }
            context("when creating view models") {
                it("makes organizations view model") {
                    let organizationsViewModel = model.makeOrganizationsViewModel()
                    expect(organizationsViewModel).notTo(beNil())
                }

                it("makes repositories view model") {
                    let repositoriesViewModel = model.makeRepositoriesViewModel()
                    expect(repositoriesViewModel).notTo(beNil())
                }
            }
        }
    }

    private
    static func makeGittyTabViewModel(all organizations: Organizations,
                                      getRepositories: @escaping (String, Organizations) -> AnyPublisher<Repositories, CustomError>) -> GittyTabViewModel {
        let modelInput = GittyTabViewModel
            .Input(allOrganizations: Just(organizations).eraseToAnyPublisher(),
                   getRepositories: getRepositories,
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard())
        let modelOutput = GittyTabViewModel
            .Output()
        return GittyTabViewModel(with: modelInput, and: modelOutput)
    }

}
