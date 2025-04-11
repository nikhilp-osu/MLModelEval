//
//  AppSettingsViewModel.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

@MainActor
final class AppSettingsViewModel: ObservableObject {
    @Published var settings = AppSettings()
    var isDarkMode: Bool { settings.isDarkMode }
}
