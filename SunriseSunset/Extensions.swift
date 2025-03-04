//
//  Extensions.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/3/25.
//

import UIKit

extension UIFont {
    static func copperPlateBold(size: CGFloat) -> UIFont {
        UIFont(name: Constant.copperPlateBold, size: size) ??
            .systemFont(ofSize: size, weight: .bold)
    }
}

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis? = nil,
                     spacing: CGFloat? = nil,
                     alignment: UIStackView.Alignment? = nil,
                     distribution: UIStackView.Distribution? = nil ) {
        self.init(frame: .zero)
        if let axis = axis {
            self.axis = axis
        }
        if let spacing = spacing {
            self.spacing = spacing
        }
        if let alignment = alignment {
            self.alignment = alignment
        }
        if let distribution = distribution {
            self.distribution = distribution
        }
    }
}

extension UILabel {
    convenience init(textAlignment: NSTextAlignment? = nil, 
                     numberOfLines: Int? = nil,
                     adjustsFontSizeToFitWidth: Bool? = nil) {
        self.init(frame: .zero)
        if let textAlignment = textAlignment {
            self.textAlignment = textAlignment
        }
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
        if let adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth {
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        }
    }
}
