//
//  ImageLoader.swift
//  RMUserDefaultsMVC
//
//  Created by Ибрагим Габибли on 29.12.2024.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private init() {}
    var counter = 1

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {

        if let imageData = StorageManager.shared.loadImage(key: urlString),
           let image = UIImage(data: imageData) {
            completion(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let data,
               let image = UIImage(data: data) {
                StorageManager.shared.saveImage(data, key: urlString)
                completion(image)
                print("Load image \(self.counter)")
                self.counter += 1
            } else {
                completion(nil)
            }
        }.resume()
    }
}
