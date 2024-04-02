//
//  AppDelegate.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit
import CoreML
import Vision

var yoloModel: YOLOv3Model?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Task { configureYOLOv3Model() }
        
        configureLaunchImage()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func configureYOLOv3Model() {
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3Int8LUT", withExtension: "mlmodelc") else {
            fatalError("Failed to find YOLOv3 model file")
        }
        do {
            let model = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            yoloModel = YOLOv3Model(model: model)
        } catch {
            fatalError("Failed to load YOLOv3 model: \(error)")
        }
    }
}

extension AppDelegate {
    private func configureLaunchImage() {
        let launchImageFileName = DataManager.shared.getLaunchImageFileName()
        
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.absoluteString ?? ""
        let launchFileFullPath = docDir + launchImageFileName
        
        let launchImageURL = URL(string: launchFileFullPath)
        
        var launchImage: UIImage = UIImage()
        
        do {
            if (launchImageURL != nil) {
                let launchImageData = try Data(contentsOf: launchImageURL!)
                launchImage = UIImage(data: launchImageData) ?? UIImage()
            }
        } catch {
            
        }
        
        if (launchImage.size.width == 0 || launchImage.size.height == 0) {
            launchImage = UIImage(named: "sea") ?? UIImage()
        }
        
        DataManager.shared.setLaunchImage(to: launchImage)
        
        Task {
            NetworkService.downloadLaunchImage()
        }
    }
}
