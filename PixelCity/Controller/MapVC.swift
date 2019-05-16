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
import Alamofire
import AlamofireImage

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
    
    
    // 050 create instance for image url array
    var imageUrlArray = [String]()
    
    // 056 create intance for image array
    var imageArray = [UIImage]()
    
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
        collectionView?.backgroundColor = UIColor.lightGray
        
        // 079 to call func 077 and 078
        registerForPreviewing(with: self, sourceView: collectionView!)
        
        
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
        // 062 call cancel func
        cancelAllSessions()
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
        
        // 063 cancel all ongoing sessions
        cancelAllSessions()
        
        // 069 clear collectionView
        imageUrlArray = []
        imageArray = []
        
        collectionView?.reloadData()
        
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
        
        // 053 call retriveUrls func. Handler hit enter
        retrieveUrls(forAnnotation: annotation) { (finished) in  // 060 to remove spinner, progress label etc as all finished. change to finished.
            if finished {
                self.retrieveImages(handler: { (finished) in
                    if finished {
                        self.removeSpinner()
                        self.removeProgressLbl()
                        self.collectionView?.reloadData()   // 068 call func collectionView
                    }
                })
            }
        }
    }
    
    
    // 025 to remove old dropped pins
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)     // call this function before function drop a pin
        }
    }
    
    // 049 func for fetching data through Alamofire from Flickr
    func retrieveUrls(forAnnotation annotation: DroppablePin, handler: @escaping (_ status: Bool) -> () ) {
        
        // 052 request data from Flickr api url through alamofire. Hit enter for completionHandler
        Alamofire.request(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, numberOfPhotos: 20)).responseJSON { (response) in
           // 053 convert any object and  data to string dictionary
            guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
            // 054 in json to get in to anyobject in dictionary
            let photosDictionary = json["photos"] as! Dictionary<String, AnyObject>
            let photosDictionaryArray = photosDictionary["photo"] as! [Dictionary<String, AnyObject>]
            for photo in photosDictionaryArray {
                let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
                self.imageUrlArray.append(postUrl)
            }
            handler(true)
        }
    }
    
    
    // 055 to fetch images
    func retrieveImages(handler: @escaping (_ status: Bool) -> ()) {
      
        for url in imageUrlArray {
            Alamofire.request(url).responseImage { (response) in
                guard let image = response.result.value else { return }
                self.imageArray.append(image)
                
                // 058 update progress label that image is downloaded
                self.progressLbl?.text = "\(self.imageArray.count) of 20 images downloaded"
                
                // 059 check if the number of images were downloaded
                if self.imageArray.count == self.imageUrlArray.count {
                    handler(true)
                }
            }
            
        }
        
    }
    
    // 061 cancel all sessions
    func cancelAllSessions() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach({ $0.cancel() })  // $0 means for task in sesssionDataTask { task.cancel }
            downloadData.forEach({ $0.cancel() })
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
        return imageArray.count   // 064 change the number to imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() } // 065 add guard and else return UICollectionViewCell
        
        
        let imageFromIndex = imageArray[indexPath.row]
        let imageView = UIImageView(image: imageFromIndex) // 066 pass to UIImage
        cell.addSubview(imageView) // 067 to show up in cell
        return cell
    }
    
    // 071 to select an object in cell and pull it up in array
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVc") as? PopVC else { return }
        
        popVC.initData(forImage: imageArray[indexPath.row])
        present(popVC, animated: true, completion: nil)
        
    }
    
}



// 076 preview feature. it has 2 func viewControllerForLocation and viewControllerToCommit
extension MapVC: UIViewControllerPreviewingDelegate {
    
    // 077 viewControllerForLocation
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location), let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC else { return nil }
        
        popVC.initData(forImage: imageArray[indexPath.row])
        
        previewingContext.sourceRect = cell.contentView.frame
        return popVC
    }
    
    // 078 viewControllerToCommit
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}
