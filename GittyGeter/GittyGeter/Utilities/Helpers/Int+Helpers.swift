//
//  Int+Helpers.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Foundation

extension Int {
    func formattedGitHubRepoSize() -> String {
        guard self >= 0 else { return "Invalid Size" }
        let sizeInBytes = Int64(self) * 1024
        let byteFormatter = ByteCountFormatter()
        byteFormatter.countStyle = .file
        return byteFormatter.string(fromByteCount: sizeInBytes)
    }
}
