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
            var database: Database!
            beforeEach {
                database = MockDatabase()
                model = Self.makeGittyTabViewModel(with: database)
            }

            afterEach {
                database = nil
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
    static func makeGittyTabViewModel(with database: Database) -> GittyTabViewModel {
        let modelInput = GittyTabViewModel
            .Input(getAllOrganizations: database.getOrganizations,
                   getRepositories: database.getRepositories(query:within:),
                   getFavouriteRepositories: database.getFavouriteRepositories,
                   updateFavoriteStatus: database.updateFavoriteStatus(of:to:),
                   fetcher: MockFetcher(),
                   configuration: Configuration.standard())
        let modelOutput = GittyTabViewModel
            .Output(userSelectedRepository: PassthroughSubject(),
                    userSelectedOrganization: PassthroughSubject())
        return GittyTabViewModel(with: modelInput, and: modelOutput)
    }

}
