//
//  PicsumService.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import UIKit

enum PicsumService {
    static func randomImages(_ n: Int, side: Int = 512) async -> [UIImage] {
        var out: [UIImage] = Array(repeating: UIImage(), count: n)
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for idx in 0..<n {
                group.addTask {
                    let seed = UUID().uuidString
                    let url = URL(string: "https://picsum.photos/seed/\(seed)/\(side)")!
                    if let (data, resp) = try? await URLSession.shared.data(from: url),
                       (resp as? HTTPURLResponse)?.statusCode == 200,
                       let img = UIImage(data: data) {
                        return (idx, img)
                    }
                    return (idx, nil)
                }
            }
            for await (idx, img) in group {
                if let i = img { out[idx] = i }
            }
        }
        return out.filter { $0.size != .zero }
    }
}
