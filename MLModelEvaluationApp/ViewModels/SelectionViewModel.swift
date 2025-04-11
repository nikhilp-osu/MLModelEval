//
//  SelectionViewModel.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import SwiftUI
import PhotosUI

@MainActor
final class SelectionViewModel: ObservableObject {
    @Published var count: Int = 5 {
        didSet {
            trimLocal()
            if usePicsum { Task { await fetchPicsum() } }
        }
    }

    @Published var usePicsum = false {
        didSet {
            reset()
            if usePicsum { Task { await fetchPicsum() } }
        }
    }

    @Published var pickerItems: [PhotosPickerItem] = [] {
        didSet {
            guard !usePicsum else { return }
            trimLocal()
            Task { await loadLocal() }
        }
    }

    @Published private(set) var images: [UIImage] = []
    @Published var overLimitAlert = false
    @Published var loadingPicsum = false
    @Published var picsumError = false

    private func trimLocal() {
        if pickerItems.count > count {
            pickerItems = Array(pickerItems.prefix(count))
            overLimitAlert = true
        }
        if images.count > count { images = Array(images.prefix(count)) }
    }

    private func loadLocal() async {
        var imgs: [UIImage] = []
        for item in pickerItems.prefix(count) {
            if let data = try? await item.loadTransferable(type: Data.self),
               let img = UIImage(data: data) {
                imgs.append(img)
            }
        }
        images = imgs
    }

    private func fetchPicsum() async {
        loadingPicsum = true
        picsumError = false
        let imgs = await PicsumService.randomImages(count)
        loadingPicsum = false
        if imgs.count == count {
            images = imgs
        } else {
            picsumError = true
            images.removeAll()
        }
    }

    func reset() {
        pickerItems.removeAll()
        images.removeAll()
        overLimitAlert = false
        loadingPicsum = false
        picsumError = false
    }
}
