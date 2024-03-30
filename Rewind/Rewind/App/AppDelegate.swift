//
//  AppDelegate.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit
import CoreML
import Vision

var tags = [String]()
var requests = [VNRequest]()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Task { setupVision() }
        
//        modelRequest(imageData: (UIImage(named: "moscow")?.jpegData(compressionQuality: 1)!)!)
        
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
    @discardableResult
    private func setupVision() -> NSError? {
        debugPrint("setupVision()")
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3", withExtension: "mlmodelc") else {
            debugPrint("Load YOLOv3.mlmodelc error!")
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    tags = results.first?.labels.prefix(5).map{ $0.identifier } ?? []
                }
            })
            requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
}

func modelRequest(imageData: Data) {
    let imageRequestHandler = VNImageRequestHandler(data: imageData)
    do {
        try imageRequestHandler.perform(requests)
    }
    catch {
    }
}
