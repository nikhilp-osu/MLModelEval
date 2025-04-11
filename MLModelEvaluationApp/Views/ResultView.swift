//
//  ResultView.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

struct ResultView: View {
    @StateObject private var vm: ResultsViewModel
    @EnvironmentObject private var pop: PopToRoot
    @Environment(\.dismiss) private var dismiss
    @State private var fireConfetti = false

    init(data: [VoteData]) {
        _vm = StateObject(wrappedValue: ResultsViewModel(data: data))
    }

    var body: some View {
        VStack(spacing: 32) {
            Text("Winner: \(vm.winner)").font(.title.weight(.bold))
            BarChartView(data: vm.data)
            Spacer()
            Button("Done") {
                dismiss()
                pop.fire()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Results")
        .navigationBarBackButtonHidden(true)
        .displayConfetti(isActive: $fireConfetti)
        .onAppear { fireConfetti = true }
    }
}

