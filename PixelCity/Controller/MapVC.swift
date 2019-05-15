//
//  ViewController.swift
//  PixelCity
//
//  Created by Kafkas Baranseli on 15/05/2019.
//  Copyright © 2019 Baranseli. All rights reserved.
//

import UIKit
import MapKit        // 001 to use maps import it
import CoreLocation  // 002 to use location features import it and use CLLocationManager


class MapVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapLbl: UILabel!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    
    
    var locationManager = CLLocationManager()       // 005 use CLLocationManager
    let authorisationStatus = CLLocationManager.authorizationStatus() // 008 to have authorisation status value
    let regionRadius: Double = 500                    // 012 to have regionRadius value
    var screenSize = UIScreen.main.bounds
    
    // 032 to create a spinner
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel? // than go to below annimateViewDown to create related funcs
    
    
    // 041 to add UICollectionView by code *****
    var collectionView: UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       mapView.delegate = self     // 006 delegation
        locationManager.delegate = self  // 007 delegation
        configureLocationServices() // 010 call this func to run as soon as the view loads
        addDoubleTap()             // 018 to call this func to run as soon as the view loads
        
        
        
        // 042 to instentiating collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)       // go to View folder and create a new CocoaTouch Class file of UICollectionViewCell subclass
        //045 collectionView features
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.green
        pullUpView.addSubview(collectionView!)
    }
    
    
    // 017 to make GestureRecognition
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }

    // 029 to return map to full screen
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)      // add this function below under 028
    }
    
    
    
    // 028 to animate the map. First set the constreint to have a new constant
    func animateViewUp() {
        pullUpViewHeightConstraint.constant = 400   // place images into
        UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()               // displays subviews
        }
       
    }
    
    // 030 for selector of 029
    @objc func animateViewDown() {
        pullUpViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 033 spinner features
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.color = UIColor.darkGray
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!) // 048 change pullUpView to CollectionView
    }
    
    // 035 remove the spinner
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    // 037 progress Label
    func addProgressLbl() {
        progressLbl = UILabel()
        progressLbl?.frame = CGRect(x: (screenSize.width / 2) - 120, y: 175, width: 240, height: 40)
        progressLbl?.font = UIFont(name: "Helvetica Neue", size: 18)
        progressLbl?.textColor = UIColor.darkGray
        progressLbl?.textAlignment = .center
        collectionView?.addSubview(progressLbl!)   // 047 change pullUpView to CollectionView
        
    }
    
    // 039 to remove progressLbl repeat
    func removeProgressLbl() {
        if progressLbl != nil {
            progressLbl?.removeFromSuperview()
        }
    }
    
    @IBAction func centreMapBtnWasPressed(_ sender: Any) {
        // 016 to make button active
        if authorisationStatus == .authorizedWhenInUse || authorisationStatus == .authorizedAlways {
            centreMapOnUserLocation()
        }
    }
    

}


//  003 extension MKMapViewDelegate to delegate MKMapView. You can do it on top or here as shown.
extension MapVC: MKMapViewDelegate {
    
    // 027 to customise the pin viewForAnnotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = UIColor.purple
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    
    //011 to centrealise the map view
    func centreMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
         // 013 select center:..., latitudinalMeters:...., longitudialMeters
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        
        // 014 to set that region
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        // 026 call this function before function drop a pin
        removePin()
        // to call the func removeSpinner
        removeSpinner()
        // 028 to call animate map func
        // 040 remove progpressLbl func call
        removeProgressLbl()
        animateViewUp()
        // 031 call swipe func
        addSwipe()
        // 034 call spinner func
        addSpinner()
        // 038 progressLbl call
        addProgressLbl()
        
        // 019 to drop pin create touch point on map
        let touchPoint = sender.location(in: mapView)
        
        // 020 now convert the touch point into a GPS coordinate
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView) // create a swift file under View and create a sub class MKAnnotation
        
        // 023 to make annotation and add it to mapView
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        //024 to centrealise where is the pin dropped
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
         mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // 025 to remove old dropped pins
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)     // call this function before function drop a pin
        }
    }
    
    
    
    
}






// 004 extension CLLocationManagerDelegate to delegate CLLocationManager. You can do it on top or here as shown.
extension MapVC: CLLocationManagerDelegate {
    
    // 009 to check our App authorised to grap our location, if not it will request services if it is it going to return
    func configureLocationServices() {
        if authorisationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    // 015 didChangeAuthorization status func must be
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centreMapOnUserLocation()
    }
    
}


// 046 create extension for collectionView features and 3 funcs
extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell
        return cell!
    }
}
