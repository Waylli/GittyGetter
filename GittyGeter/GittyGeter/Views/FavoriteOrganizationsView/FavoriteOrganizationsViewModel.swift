//
//  FavoriteOrganizationsViewModel.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

class FavoriteOrganizationsViewModel: ObservableObject {

    @Published private(set) var favoriteRepositories = Repositories()

    let input: Input
    let output: Output

    init(with input: Input,
         and output: Output) {
        self.input = input
        self.output = output
    }

}

extension FavoriteOrganizationsViewModel {

    struct Input {

    }

    struct Output {

    }

}
