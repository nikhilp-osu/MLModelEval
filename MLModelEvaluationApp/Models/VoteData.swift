//
//  VoteData.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import Foundation

struct VoteData: Identifiable {
    let id = UUID()
    let modelName: String
    let votes: Int
}
