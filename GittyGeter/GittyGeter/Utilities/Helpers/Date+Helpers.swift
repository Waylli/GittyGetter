//
//  Date+Helpers.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Foundation

extension Date {
    func readable() -> String {
        let formater = DateFormatter()
        formater.timeStyle = .none
        formater.dateStyle = .medium
        return formater.string(from: self)
    }
}
