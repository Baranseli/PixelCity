//
//  DroppablePin.swift
//  PixelCity
//
//  Created by Kafkas Baranseli on 15/05/2019.
//  Copyright © 2019 Baranseli. All rights reserved.
//

import Foundation
import UIKit // 021 import UIKit
import MapKit // 022 import MapKit

class DroppablePin: NSObject, MKAnnotation {
    
   dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()                          // then go back to MapVc
    }
    
}



