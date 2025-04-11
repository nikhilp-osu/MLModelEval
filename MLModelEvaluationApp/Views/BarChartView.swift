//
//  BarChartView.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI
import Charts

struct BarChartView: View {
    let data: [VoteData]

    var body: some View {
        Chart(data) { d in
            BarMark(x: .value("Model", d.modelName),
                    y: .value("Votes", d.votes))
            .annotation(position: .top) { Text("\(d.votes)") }
        }
        .chartYAxis(.hidden)
        .frame(height: 250)
    }
}

