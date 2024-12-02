//
//  String+Helepers.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

#if DEBUG || TESTING
extension String {
    static
    func random() -> String {
        UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }

}
#endif
