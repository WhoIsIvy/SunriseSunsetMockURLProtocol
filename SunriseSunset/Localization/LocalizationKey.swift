//
//  LocalizationKey.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import Foundation

enum LocalizableKey: String.LocalizationValue {
    case disclaimer
    case emptyZip
    case invalidLocation
    case invalidTimes
    case sunrise
    case sunset
    case unknownErrorText
    case zipInvalidDigit
    case zipInvalidDigitCount
    case zipPlaceholder
}

extension String {
    static func localization(key: LocalizableKey) -> String {
        .init(localized: key.rawValue)
    }
}
