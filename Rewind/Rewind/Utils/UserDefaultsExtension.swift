//
//  UserDefaultsExtension.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 03.03.2024.
//

import UIKit

extension UserDefaults {
    func setImage(_ image: UIImage?, forKey key: String) {
        guard let image = image else {
            removeObject(forKey: key)
            return
        }
        if let data = image.jpegData(compressionQuality: 1.0) {
            set(data, forKey: key)
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        guard let data = data(forKey: key) else {
            return nil
        }
        return UIImage(data: data)
    }
}
