//
//  MLModelEvaluationAppApp.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

@main
struct MLModelEvaluationAppApp: App {
    @StateObject private var settingsVM = AppSettingsViewModel()
    @StateObject private var popToRoot  = PopToRoot()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                StartView()
            }
            .environmentObject(settingsVM)
            .environmentObject(popToRoot)
            .preferredColorScheme(settingsVM.isDarkMode ? .dark : .light)
        }
    }
}


