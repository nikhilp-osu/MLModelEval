//
//  NumberInputView.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI
import PhotosUI

struct NumberInputView: View {
    @StateObject private var vm = SelectionViewModel()
    @EnvironmentObject private var pop: PopToRoot
    @Environment(\.dismiss) private var dismiss
    @State private var ready = false

    private var localReady: Bool { vm.images.count == vm.count && vm.count > 0 }
    private var picsumReady: Bool { !vm.loadingPicsum && vm.images.count == vm.count }
    private var continueEnabled: Bool { vm.usePicsum ? picsumReady : localReady }

    var body: some View {
        VStack(spacing: 24) {
            Text("Select how many images")
                .font(.title3.weight(.semibold))

            Stepper("Images: \(vm.count)", value: $vm.count, in: 1...20)
                .padding(.horizontal)

            Toggle("Random images from Lorem Picsum", isOn: $vm.usePicsum)
                .padding(.horizontal)

            if vm.usePicsum {
                if vm.loadingPicsum {
                    ProgressView("Fetching…").padding()
                } else if vm.picsumError {
                    Text("Couldn't fetch images, try again.").foregroundColor(.red)
                } else if picsumReady {
                    Text("Images fetched ✓").foregroundColor(.green)
                }
            } else {
                PhotosPicker(selection: $vm.pickerItems,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Label("Pick Photos", systemImage: "photo.on.rectangle")
                }
                .buttonStyle(.borderedProminent)
            }

            Button("Continue") { ready = true }
                .buttonStyle(.borderedProminent)
                .disabled(!continueEnabled)

            NavigationLink(isActive: $ready) {
                EvaluationView(images: vm.images)
            } label: { EmptyView() }
        }
        .padding()
        .navigationTitle("Select Images")
        .navigationBarBackButtonHidden(true)
        .toolbar { ToolbarItem(placement: .navigationBarLeading) { Button("Back") { dismiss() } } }
        .alert("You selected more than \(vm.count) images. Try again.",
               isPresented: $vm.overLimitAlert) {
            Button("OK", role: .cancel) { vm.reset() }
        }
        .onChange(of: pop.trigger) { flag in if flag { dismiss() } }
    }
}
