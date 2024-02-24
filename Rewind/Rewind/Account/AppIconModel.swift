//
//  AppIconModel.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.02.2024.
//

import Foundation

enum AppIcon: String, CaseIterable {
    case AppIconWhite
    case AppIconPink
    case AppIconFlowers
    case AppIconBlue
    case AppIconGreen
    case AppIconGradient
    case AppIconGradientCircle
    
    static func indexForCase(withValue stringValue: String) -> Int? {
        for (index, caseValue) in AppIcon.allCases.enumerated() {
            if caseValue.rawValue == stringValue {
                return index
            }
        }
        return nil
    }
}
