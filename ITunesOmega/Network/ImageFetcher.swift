//
//  ImageFetcher.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 20.02.2022.
//

import Foundation
import UIKit

class ImageFetcher {

    static let shared = ImageFetcher()

    func fetchImage(with url: String, completion: @escaping (ImageFetchResult) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: url), let imgData = try? Data(contentsOf: url),
               let image = UIImage(data: imgData) {
                completion(.success(image: image))
            } else {
                completion(.failed)
            }
        }
    }

}

enum ImageFetchResult {
    case success(image: UIImage)
    case failed
}
