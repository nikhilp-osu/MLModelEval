//
//  ModelCardView.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

struct ModelCardView: View {
    let prediction: Prediction
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(prediction.modelName).bold()
                Text(prediction.label).font(.subheadline)
            }
            Spacer()
            ZStack {
                Circle().stroke(lineWidth: 6).opacity(0.3)
                Circle()
                    .trim(from: 0, to: prediction.confidence)
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(String(format: "%.0f%%", prediction.confidence * 100))
                    .font(.footnote.weight(.semibold))
            }
            .frame(width: 48, height: 48)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
