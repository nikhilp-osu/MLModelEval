//
//  ConfettiView.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    @State private var xSpeed  = Double.random(in: 0.7...2)
    @State private var zSpeed  = Double.random(in: 1...2)
    @State private var anchor  = CGFloat.random(in: 0...1).rounded()

    var body: some View {
        Rectangle()
            .fill([.orange, .green, .blue, .red, .yellow].randomElement()!)
            .frame(width: 14, height: 14)
            .onAppear { animate = true }
            .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (1, 0, 0))
            .animation(.linear(duration: xSpeed).repeatForever(autoreverses: false), value: animate)
            .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (0, 0, 1),
                              anchor: UnitPoint(x: anchor, y: anchor))
            .animation(.linear(duration: zSpeed).repeatForever(autoreverses: false), value: animate)
    }
}

struct ConfettiContainerView: View {
    var count = 60
    @State private var yPos: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { _ in
                ConfettiView()
                    .position(x: .random(in: 0...UIScreen.main.bounds.width),
                              y: yPos != 0
                              ? .random(in: 0...UIScreen.main.bounds.height)
                              : yPos)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .onAppear { yPos = .random(in: 0...UIScreen.main.bounds.height) }
    }
}

struct DisplayConfettiModifier: ViewModifier {
    @Binding var isActive: Bool {
        didSet { if !isActive { opacity = 1 } }
    }
    @State private var opacity = 1.0 {
        didSet { if opacity == 0 { isActive = false } }
    }

    private let showTime = 3.0
    private let fadeTime = 2.0

    func body(content: Content) -> some View {
        content
            .overlay(isActive ? ConfettiContainerView().opacity(opacity) : nil)
            .task { await runSequence() }
    }

    private func runSequence() async {
        guard isActive else { return }
        try? await Task.sleep(nanoseconds: UInt64(showTime * 1_000_000_000))
        await MainActor.run {
            withAnimation(.easeOut(duration: fadeTime)) { opacity = 0 }
        }
    }
}

extension View {
    func displayConfetti(isActive: Binding<Bool>) -> some View {
        modifier(DisplayConfettiModifier(isActive: isActive))
    }
}
