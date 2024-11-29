//
//  AppFetcher.swift
//  GittyGeter
//
//  Created by Petar Perkovski on 29/11/2024.
//

import Foundation
import Kingfisher
import Combine

class AppFetcher {

//    private let cacheName = "KingfisherTempCacheName" // Fixed the typo

}

extension AppFetcher: Fetcher {

    func fetchPhoto(from string: String) -> AnyPublisher<Photo, CustomError> {
        guard let url = URL(string: string) else {
            // New error type for invalid URL
            return Fail(error: CustomError.dataMappingFailed)
                .eraseToAnyPublisher()
        }

        // Use the URL string as a cache key to ensure uniqueness
        let resource = KF.ImageResource(downloadURL: url, cacheKey: string)
        let options = getOptions()

        return Future<Photo, CustomError> { promise in
            KingfisherManager.shared
                .retrieveImage(with: resource,
                               options: options,
                               progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        promise(.success(value.image))
                    case .failure:
                        promise(.failure(CustomError.objectNotFound))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    private func getOptions() -> KingfisherOptionsInfo {
        let processor = KingFisherProcessor()
        // Use the default cache to ensure that caching works properly
        let cache = ImageCache.default

        return [
            .processor(processor),
            .cacheOriginalImage,
            .targetCache(cache), // Store in the target cache
            .memoryCacheExpiration(.days(7)), // Optional: Configure cache expiration
            .diskCacheExpiration(.days(30)), // Optional: Configure cache expiration on disk
            .backgroundDecode // Decode in the background
        ]
    }

    private struct KingFisherProcessor: ImageProcessor {
        let identifier: String = "KingFisherProcessor"
        func process(item: ImageProcessItem,
                     options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
            switch item {
            case .image(let image):
                return image
            case .data(let data):
                return Photo(data: data) // Assuming Photo can convert data to image
            }
        }
    }

}

