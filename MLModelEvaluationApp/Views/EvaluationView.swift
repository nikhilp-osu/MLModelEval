//
//  EvaluationView.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

struct EvaluationView: View {
    @StateObject private var vm: EvaluationViewModel
    @EnvironmentObject private var pop: PopToRoot
    @Environment(\.dismiss) private var dismiss

    @State private var biasAlert  = false
    @State private var biasShown  = false
    @State private var voteAlert  = false
    @State private var goResults  = false

    init(images: [UIImage]) {
        _vm = StateObject(wrappedValue: EvaluationViewModel(images: images))
    }

    var body: some View {
        VStack(spacing: 16) {
            if !vm.finished {
                Image(uiImage: vm.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
            }

            if vm.predictions.isEmpty && !vm.finished {
                ProgressView().padding()
            } else if !vm.finished {
                ForEach(vm.predictions) { ModelCardView(prediction: $0) }

                HStack {
                    ForEach(vm.predictions) { p in
                        Button(p.modelName) { vm.vote(modelName: p.modelName) }
                            .buttonStyle(.borderedProminent)
                    }
                }

                Button(vm.noneButtonLabel) { vm.vote(modelName: vm.noneButtonLabel) }
                    .buttonStyle(.bordered)
                    .padding(.top, 4)
            }

            NavigationLink(isActive: $goResults) {
                ResultView(data: vm.voteData)
            } label: { EmptyView() }
        }
        .padding()
        .navigationTitle("Evaluate")
        .navigationBarBackButtonHidden(true)
        .toolbar { ToolbarItem(placement: .navigationBarLeading) { Button("Close") { dismiss() } } }

        .onAppear {
            if !biasShown {
                biasAlert = true
                biasShown = true
            }
        }

        .onChange(of: pop.trigger) { if $0 { dismiss() } }

        .onChange(of: vm.finished) { finished in
            if finished && !biasAlert { voteAlert = true }
        }

        .onChange(of: biasAlert) { dismissed in
            if !dismissed && vm.finished { voteAlert = true }
        }

        .alert("AI Bias Notice",
               isPresented: $biasAlert,
               actions: { Button("Continue", role: .cancel) { } },
               message: { Text("Predictions may reflect biases present in the training data. Interpret results carefully.") })

        .alert(vm.summaryString,
               isPresented: $voteAlert,
               actions: { Button("OK") { goResults = true } })
    }
}
