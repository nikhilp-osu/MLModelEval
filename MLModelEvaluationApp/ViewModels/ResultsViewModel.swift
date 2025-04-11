//
//  ResultsViewModel.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

@MainActor
final class ResultsViewModel: ObservableObject {
    let data: [VoteData]
    init(data: [VoteData]) { self.data = data }
    var winner: String { data.max(by: { $0.votes < $1.votes })?.modelName ?? "-" }
}
