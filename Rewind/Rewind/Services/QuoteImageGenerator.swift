//
//  QuoteImageGenerator.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 29.03.2024.
//

import UIKit

final class QuoteImageGenerator {
    static func convertToImage(quote: String, author: String, backgroundColor: UIColor, textColor: UIColor) -> UIImage? {
        let quoteRowsMax = 10
        let quoteCharactersPerRow = 18
        let authorCharactersPerRow = 20
        let quoteHeightFactor = 1.2
        let authorHeightFactor = 1.2
        let minRowsCount: Int = 10
        var s: String = ""
        var ss: [String] = []
        
        s = quote.trim().replacingOccurrences(of: "\r", with: " ").replacingOccurrences(of: "\n", with: " ")
        
        while s.index(of: "  ") != nil {
            s = s.replacingOccurrences(of: "  ", with: " ")
        }
        
        s = String(s.prefix(quoteCharactersPerRow * quoteRowsMax))
        ss = s.splitByCharacterCount(quoteCharactersPerRow)
        
        var quoteRowsCount = ss.count
//        print(#function + ": quoteRowsCount=\(quoteRowsCount)")
        
        var newQuote = ""
        if quoteRowsCount < minRowsCount {
            for _ in 0..<(minRowsCount - quoteRowsCount) / 2 {
                newQuote += "\n"
                quoteRowsCount += 1
            }
        }
        
        if quoteRowsCount > 8 {
            return nil
        }
        
        newQuote += s
//        print(#function + ": quoteRowsCount=\(quoteRowsCount)")
        
        s = author.trim().replacingOccurrences(of: "\r", with: " ").replacingOccurrences(of: "\n", with: " ")
        
        while s.index(of: "  ") != nil {
            s = s.replacingOccurrences(of: "  ", with: " ")
        }
        
        s = String(s.prefix(authorCharactersPerRow))
        ss = s.splitByCharacterCount(authorCharactersPerRow)
        
        let authorRowsCount = ss.count
        var newAuthor = ""
        
        newAuthor += s
//        debugPrint(#function + ": authorRowsCount=\(authorRowsCount)")
        
        let quoteFontSize: CGFloat = 30
        let authorFontSize: CGFloat = 20
        let imageSize = CGSize(width: 380, height: 380)
        let quoteFont = UIFont.monospacedSystemFont(ofSize: quoteFontSize, weight: .medium)
        let authorFont = UIFont.monospacedSystemFont(ofSize: authorFontSize, weight: .medium)
        
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        let image = renderer.image { ctx in
            backgroundColor.setFill()
            ctx.fill(CGRect(origin: .zero, size: imageSize))
            
            let quotePparagraphStyle = NSMutableParagraphStyle()
            quotePparagraphStyle.alignment = .center
            
            let quoteTextAttributes: [NSAttributedString.Key: Any] = [.font: quoteFont, .foregroundColor: textColor, .paragraphStyle: quotePparagraphStyle]
            
            let authorPparagraphStyle = NSMutableParagraphStyle()
            authorPparagraphStyle.alignment = .right
            
            let authorTextAttributes: [NSAttributedString.Key: Any] = [.font: authorFont, .foregroundColor: textColor, .paragraphStyle: authorPparagraphStyle]
            
            let quoteRect = CGRect(x: 20, y: 20, width: imageSize.width - 40, height: imageSize.height)
            let authorRect = CGRect(x: 20, y: imageSize.height - authorFontSize - CGFloat(authorRowsCount) * authorFontSize * authorHeightFactor, width: imageSize.width - 60, height: imageSize.height / 2)
            
            newQuote.draw(in: quoteRect, withAttributes: quoteTextAttributes)
            newAuthor.draw(in: authorRect, withAttributes: authorTextAttributes)
        }
        
        return image
    }
}
