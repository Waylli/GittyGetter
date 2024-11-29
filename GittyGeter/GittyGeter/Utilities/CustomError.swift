//
//  CustomError.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 26/11/2024.
//

import Foundation

enum CustomError: Error {
    case networkError,
         objectNotFound,
         dataMappingFailed,
         localDatabaseError,
         unknown(Error)
}

extension CustomError {
    static
    func from(any error: Error) -> CustomError {
        // handle it better when you have the time
        .unknown(error)
    }
}
