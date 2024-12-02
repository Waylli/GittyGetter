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


import SwiftUI

extension String {
    func toColor() -> Color {
        let hex = self.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        guard hex.count == 6 || hex.count == 8 else {
            assertionFailure("not a valid hex")
            return Color.white.opacity(0.001)
        }
        var int: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&int) else {
            assertionFailure("not a valid hex")
            return Color.white.opacity(0.001)
        }
        let r, g, b, a: Double
        if hex.count == 6 {
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
            a = 1.0
        } else {
            r = Double((int >> 24) & 0xFF) / 255.0
            g = Double((int >> 16) & 0xFF) / 255.0
            b = Double((int >> 8) & 0xFF) / 255.0
            a = Double(int & 0xFF) / 255.0
        }
        return Color(red: r, green: g, blue: b, opacity: a)
    }
}
