//
//  UIImageExtension.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 24.03.2024.
//

import AVFoundation
import UIKit

extension UIImage {
    convenience init?(base64String: String) {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        self.init(data: imageData)
    }
    func resize(toDimension dimension: Int) -> UIImage {
        var targetSize = CGSize(width: dimension, height: dimension)
        
        let widthScaleRatio = targetSize.width / self.size.width
        let heightScaleRatio = targetSize.height / self.size.height
        
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        let scaledImageSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
        
        let newWidth = Int(scaledImageSize.width)
        let newHeight = Int(scaledImageSize.height)
        
        let maxSize = CGSize(width: newWidth, height: newHeight)
        let availableRect = AVFoundation.AVMakeRect(aspectRatio: self.size, insideRect: .init(origin: .zero, size: maxSize))
        
        targetSize = availableRect.size
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        let resized = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resized
    }
}

extension UIImage {
    func getPixelColor(row: Int, col: Int) -> UIColor {
        guard let cgImage = cgImage, let pixelData = cgImage.dataProvider?.data else {
            return UIColor()
        }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let bytesPerRow = cgImage.bytesPerRow
//        let width = cgImage.width
//        let height = cgImage.height
        
        let x = col
        let y = row
        
        let byteIndex = (bytesPerRow * y) + x * bytesPerPixel
        
        let red = CGFloat(data[byteIndex + 0]) / 255.0
        let green = CGFloat(data[byteIndex + 1]) / 255.0
        let blue = CGFloat(data[byteIndex + 2]) / 255.0
        let alpha = CGFloat(data[byteIndex + 3]) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
