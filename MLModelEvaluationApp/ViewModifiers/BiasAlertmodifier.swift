//
//  BiasAlertmodifier.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

struct BiasAlertModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content.alert("AI Bias Notice",
                      isPresented: $isPresented,
                      actions: { Button("Continue", role: .cancel) { } },
                      message: { Text("Predictions may reflect biases present in the training data. Interpret results carefully.") })
    }
}

extension View {
    func biasAlert(isPresented: Binding<Bool>) -> some View {
        modifier(BiasAlertModifier(isPresented: isPresented))
    }
}
