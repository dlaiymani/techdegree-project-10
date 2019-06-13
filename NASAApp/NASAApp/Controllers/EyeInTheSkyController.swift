//
//  EyeInTheSkyController.swift
//  NASAApp
//
//  Created by davidlaiymani on 13/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage

class EyeInTheSkyController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    
    private let earthPhotoAPIClient = APIClient()
    
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self, permissionsDelegate: nil)
    }()
    
    
    var coordinate: Coordinate? {
        didSet {
            if let coordinate = coordinate {
                //showNearByRestaurant(at: coordinate)
            }
        }
    }
    
    var isAuthorized: Bool {
        let isAuthorizedForLocation = LocationManager.isAuthorized
        return isAuthorizedForLocation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.imageView.isHidden = true
        self.activityIndicator.color = .white
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            checkPermissions()
        }
    }
    
    
    
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            let locationInView = sender.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView , toCoordinateFrom: mapView)
            addAnnotation(coordinate: tappedCoordinate)
            let coordinate = Coordinate(location: tappedCoordinate)
            self.obtainedCoordinates(coordinate)
        }
        
    }
    
    func addAnnotation(coordinate:CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func checkPermissions() {
        do {
            try locationManager.requestLocationAuthorization()
        } catch LocationError.disallowedByUser {
            self.showAlert(withTitle: "ReminderApp needs your location data", message: "Please, see your settings configuration")
        } catch let error {
            print("Location Authorization error \(error.localizedDescription)")
        }
    }
    
    func adjustMap(with coordinate: Coordinate) {
        let coordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion.init(center: coordinate2D, latitudinalMeters: 2500, longitudinalMeters: 2500)
        
        // let region = MKCoordinateRegion.init(center: coordinate2D, span: span)
        mapView.setRegion(region, animated: true)
        
//        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
//        myAnnotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
//     //   myAnnotation.title = "Current location"
//        mapView.addAnnotation(myAnnotation)
        
        addAnnotation(coordinate: CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))
        
        
    }
    
    func fetchEarthPhoto(forCoordinate coordinate: Coordinate) {
        
        let urlString = "https://api.nasa.gov/planetary/earth/imagery/?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&api_key=abONaFIip0FrAmEcZLiXbZqIUw2r7dOUPmRFWZMN"
        
        guard let roverUrl = URL(string: urlString) else {
            return
        }
        
        earthPhotoAPIClient.execute(roverUrl) { (jsonData, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let jsonData = jsonData {
                    let decoder = JSONDecoder()
                    let photo = try! decoder.decode(EarthPhoto.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.displayPhoto(url: photo.earthPhotoSource)
                    }
                }
            }
        }
    }
    
    
    func displayPhoto(url: String) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                DispatchQueue.main.async {
                    self.imageView.isHidden = false
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }
    
}


// MARK: - Location Manager Delegate
extension EyeInTheSkyController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        adjustMap(with: coordinate)
        print(coordinate.latitude)
        print(coordinate.longitude)
        self.activityIndicator.isHidden = false
        imageView.isHidden = true
        activityIndicator.startAnimating()
        fetchEarthPhoto(forCoordinate: coordinate)
        
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}
