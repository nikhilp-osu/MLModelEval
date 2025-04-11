//
//  PopToRoot.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

@MainActor
final class PopToRoot: ObservableObject {
    @Published var trigger = false
    func fire()  { trigger.toggle() }
    func reset() { trigger = false }
}

