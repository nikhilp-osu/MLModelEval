//
//  StartView.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject private var settingsVM: AppSettingsViewModel
    @EnvironmentObject private var pop: PopToRoot

    var body: some View {
        VStack(spacing: 40) {
            Text("ML Model Evaluation")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
                .padding(.top, 60)

            Toggle("Dark Mode", isOn: $settingsVM.settings.isDarkMode)
                .tint(.white)
                .padding(.horizontal)

            NavigationLink { NumberInputView() } label: {
                Text("Start")
                    .fontWeight(.bold)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .foregroundColor(.accentColor)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.purple, Color.blue, Color.cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .onAppear { pop.reset() }
    }
}
