//
//  String+Helepers.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

#if DEBUG
extension String {
    static
    func random() -> String {
        UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }

    static
    func orgName() -> String {
        ["Pera Wallet", "Algorand Foundation", "Algorand"].randomElement() ?? "Algorand"
    }

}
#endif
