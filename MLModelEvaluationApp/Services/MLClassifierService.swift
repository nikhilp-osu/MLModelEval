//
//  MLClassifierService.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import CoreML
import Vision
import UIKit

@MainActor
final class MLClassifierService {
    static let shared = MLClassifierService()
    private init() {}

    private let models: [(String, VNCoreMLModel)] = {
        let cfg = MLModelConfiguration()
        return [
            ("MobileNetV2", try! VNCoreMLModel(for: MobileNetV2(configuration: cfg).model)),
            ("Resnet50",    try! VNCoreMLModel(for: Resnet50(configuration: cfg).model)),
            ("YOLOv3",      try! VNCoreMLModel(for: YOLOv3FP16(configuration: cfg).model))
        ]
    }()

    func predict(image: UIImage) async -> [Prediction] {
        guard
            let cg416 = await ImageUtils.resize(image: image, maxSide: 416)?.cgImage,
            let cg224 = await ImageUtils.resize(image: image, maxSide: 224)?.cgImage
        else { return [] }

        var output: [String: Prediction] = [:]

        await withTaskGroup(of: (String, Prediction).self) { group in
            for (name, model) in models {
                group.addTask {
                    let cg      = name == "YOLOv3" ? cg416 : cg224
                    let handler = VNImageRequestHandler(cgImage: cg)
                    let req     = VNCoreMLRequest(model: model)
                    req.imageCropAndScaleOption = name == "YOLOv3" ? .scaleFill : .centerCrop
                    try? handler.perform([req])

                    if name == "YOLOv3",
                       let objs = req.results as? [VNRecognizedObjectObservation],
                       let best = objs.flatMap({ $0.labels }).max(by: { $0.confidence < $1.confidence }),
                       best.confidence >= 0.05 {
                        return (name,
                                Prediction(modelName: name,
                                           label: best.identifier,
                                           confidence: Double(best.confidence)))
                    }

                    if let cls = (req.results as? [VNClassificationObservation])?.first {
                        return (name,
                                Prediction(modelName: name,
                                           label: cls.identifier,
                                           confidence: Double(cls.confidence)))
                    }

                    return (name, Prediction(modelName: name, label: "-", confidence: 0))
                }
            }
            for await (name, pred) in group { output[name] = pred }
        }

        return models.map { output[$0.0]! }
    }


    var modelNames: [String] { models.map { $0.0 } }
}
