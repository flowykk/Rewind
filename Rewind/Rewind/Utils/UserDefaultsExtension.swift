//
//  UserDefaultsExtension.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 03.03.2024.
//

import UIKit

extension UserDefaults {
    func setImage(_ imageData: Data?, forKey key: String) {
        guard let data = imageData else {
            removeObject(forKey: key)
            return
        }
        
        set(data, forKey: key)
    }
    
    func image(forKey key: String) -> UIImage? {
        guard let data = data(forKey: key) else {
            return nil
        }
        
        return UIImage(data: data)
    }
}
