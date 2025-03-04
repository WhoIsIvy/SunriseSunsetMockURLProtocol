//
//  Attributed.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import UIKit

enum Attributed {
    case additional
    case disclaimer
    case placeholder
    case sun
    case textfield
    case title


    var textColor: UIColor {
        self == .placeholder ? .lightGray : .black
    }

    var fontSize: CGFloat {
        switch self {
        case .title, .sun: 48
        case .additional, .disclaimer: 24
        case .placeholder, .textfield: 18
        }
    }

    var fontWeight: UIFont.Weight {
        switch self {
        case .sun, .additional:
            return .thin
        default:
            return .regular
        }
    }

    var font: UIFont {
        switch self {
        case .title:
            return .copperPlateBold(size: fontSize)
        default:
            return .systemFont(ofSize: fontSize, weight: fontWeight)
        }
    }

    func attributed(_ text: String) -> NSAttributedString {
        .init(string: text, attributes: [.foregroundColor: textColor, .font: font])
    }
}
