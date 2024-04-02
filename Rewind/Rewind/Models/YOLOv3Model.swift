//
//  YOLOv3Model.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import UIKit
import Vision
import CoreML

final class YOLOv3Model {
    
    let model: VNCoreMLModel
    
    init(model: VNCoreMLModel) {
        self.model = model
    }
    
    func performObjectDetection(with imageData: Data, completion: @escaping ([VNRecognizedObjectObservation]?, Error?) -> Void) {
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                completion(nil, error ?? NSError(domain: "Vision", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process object detection"]))
                return
            }
            completion(results, nil)
        }
        
        let handler = VNImageRequestHandler(data: imageData)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(nil, error)
            }
        }
    }
}
