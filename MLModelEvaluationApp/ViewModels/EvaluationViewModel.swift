//
//  EvaluationViewModel.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

@MainActor
final class EvaluationViewModel: ObservableObject {
    @Published private(set) var index = 0
    @Published private(set) var predictions: [Prediction] = []
    @Published private(set) var image: UIImage
    @Published private(set) var votes: [String: Int] = [:]

    private let images: [UIImage]
    private let noneLabel = "None"

    init(images: [UIImage]) {
        self.images = images
        self.image  = images.first ?? UIImage()
        if !images.isEmpty { Task { await classifyCurrent() } }
    }

    private func classifyCurrent() async {
        predictions = await MLClassifierService.shared.predict(image: image)
    }

    func vote(modelName: String) {
        votes[modelName, default: 0] += 1
        if index + 1 < images.count {
            index += 1
            image = images[index]
            Task { await classifyCurrent() }
        } else {
            index += 1
        }
    }

    var finished: Bool { index >= images.count }

    var voteData: [VoteData] {
        (MLClassifierService.shared.modelNames + [noneLabel]).map {
            VoteData(modelName: $0, votes: votes[$0, default: 0])
        }
    }

    var noneButtonLabel: String { noneLabel }

    var summaryString: String {
        "Recorded \(votes.values.reduce(0,+)) votes for \(images.count) images."
    }
}
