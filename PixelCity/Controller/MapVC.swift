//
//  ViewController.swift
//  PixelCity
//
//  Created by Kafkas Baranseli on 15/05/2019.
//  Copyright © 2019 Baranseli. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage

class MapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapLbl: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       mapView.delegate = self
    }

    
    @IBAction func centreMapBtnWasPressed(_ sender: Any) {
    }
    

}



extension MapVC: MKMapViewDelegate {
    
}
