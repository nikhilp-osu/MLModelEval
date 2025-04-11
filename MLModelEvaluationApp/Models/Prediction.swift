//
//  Prediction.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import Foundation

struct Prediction: Identifiable {
    let id = UUID()
    let modelName: String
    let label: String
    let confidence: Double
}
