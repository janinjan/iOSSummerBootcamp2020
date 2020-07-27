//
//  ImageCache.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/19/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

extension UIImageView {

    public static var imageStore: [String: UIImage] = [:]

    public func setImage(with imageURL: URL) {
        let key = "\(imageURL)"
        if let cachedImage = UIImageView.imageStore[key] {
            image = cachedImage
        }

        let task = URLSession.shared.downloadTask(with: imageURL) { location, response, error in

            guard let location = location,
                  let imageData = try? Data(contentsOf: location),
                  let image = UIImage(data: imageData) else {
                return
            }
            DispatchQueue.main.async {
                UIImageView.imageStore[key] = image
                self.image = image
            }
        }
        task.resume()
    }
}
