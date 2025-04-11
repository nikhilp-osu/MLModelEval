//
//  ImageUtils.swift
//  MLModelEvaluationApp
//
//  Created by Palamoni, Nikhil Palamoni on 4/10/25.
//

import UIKit

enum ImageUtils {
    static func resize(image: UIImage, maxSide: CGFloat) async -> UIImage? {
        await withCheckedContinuation { c in
            DispatchQueue.global(qos: .userInitiated).async {
                let ratio = maxSide / max(image.size.width, image.size.height)
                let size = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
                let img = UIGraphicsImageRenderer(size: size).image { _ in image.draw(in: CGRect(origin: .zero, size: size)) }
                c.resume(returning: img)
            }
        }
    }
}
