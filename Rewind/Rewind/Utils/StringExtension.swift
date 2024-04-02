//
//  StringExtension.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.03.2024.
//

import Foundation
import CryptoKit

extension String {
    func sha256() -> String {
        if let data = self.data(using: .utf8) {
            let hashedData = SHA256.hash(data: data)
            let hashedString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
            return hashedString
        } else {
            return ""
        }
    }
}

extension String {
    func splitByCharacterCount(_ count: Int) -> [String] {
        var result: [String] = []
        
        if self.count <= count {
            result.append(self)
        } else {
            var currentIndex = self.startIndex
            
            while currentIndex < self.endIndex {
                let nextIndex = self.index(currentIndex, offsetBy: count, limitedBy: self.endIndex) ?? self.endIndex
                
                if let lastSeparatorIndex = self[currentIndex..<nextIndex].rangeOfCharacter(from: .whitespacesAndNewlines, options: .backwards)?.lowerBound {
                    result.append(String(self[currentIndex..<lastSeparatorIndex]))
                    currentIndex = self.index(after: lastSeparatorIndex)
                } else {
                    result.append(String(self[currentIndex..<nextIndex]))
                    currentIndex = nextIndex
                }
            }
        }
        
        return result
    }
}

extension String{
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
