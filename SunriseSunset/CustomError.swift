//
//  CustomError.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import Foundation

enum CustomError: Error {
    case badURL
    case invalidLocation
    case invalidTimes
    case zipEmpty
    case zipInvalidCount
    case zipInvalidCharacter
}

extension CustomError: CustomStringConvertible {
    var description: String {
        switch self {
        case .badURL:
            return .localization(key: .unknownErrorText)
        case .invalidLocation:
            return .localization(key: .invalidLocation)
        case .invalidTimes:
            return .localization(key: .invalidTimes)
        case .zipEmpty:
            return .localization(key: .emptyZip)
        case .zipInvalidCount:
            return .localization(key: .zipInvalidDigitCount)
        case .zipInvalidCharacter:
            return .localization(key: .zipInvalidDigit)
        }
    }
}
