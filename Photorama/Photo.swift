//
//  Photo.swift
//  Photorama
//
//  Created by Sami Taha on 6/14/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation

class Photo {

    let title : String
    let remoteURL : URL
    let photoID : String
    let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title  = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken =  dateTaken
    }
}

extension Photo : Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
