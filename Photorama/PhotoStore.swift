//
//  PhotoStore.swift
//  Photorama
//
//  Created by Sami Taha on 6/14/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation
import UIKit
enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError : Error {
    case imageCreationError
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let photoURL = photo.remoteURL
        let photKey = photo.photoID
        
        /// See if image is cached or stored locally
        /// If so, that is an early exit
        if let image = imageStore.image(forKey: photKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        /// Otherwise, proceed with making a request
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
 
            /// If the result is a success,
            /// then set a local variable called image
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                /// could not create image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        return .success(image)
    }
    
    
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlikrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
    
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlikrAPI.photos(fromJSON: jsonData)
    }








}
