//
//  Constants.swift
//  PixelCity
//
//  Created by Kafkas Baranseli on 16/05/2019.
//  Copyright © 2019 Baranseli. All rights reserved.
//

import Foundation
//  047 go to register to flickr then get apikey
let apiKey = "2dd35ecfe46dc994e6e624dec6a764fd"

// 048 write next func with retun api address add features
func flickrUrl(forApiKey key: String, withAnnotation annotation: DroppablePin, numberOfPhotos number: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&per_page=\(number)&format=json&nojsoncallback=1"
    
}
