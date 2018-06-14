//
//  ImageStore.swift
//  Homepwner
//
//  Created by Sami Taha on 6/13/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        /// Create a full URL for iamge
        let url = imageURL(forKey: key)
        
        /// Turn image into JPEG data
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            /// Write it to full url
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        
        /// Return image if it already exists in the cache
        if let existingImage = cache.object(forKey: key as NSString) {
            return cache.object(forKey: key as NSString)
        }
        
        ///Otherwise, see if image exists in disk
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        ///Add the newly fetched image into the cache
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
        
        
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
    
}
