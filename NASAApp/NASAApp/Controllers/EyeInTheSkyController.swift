//
//  EyeInTheSkyController.swift
//  NASAApp
//
//  Created by davidlaiymani on 13/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit
import MapKit

class EyeInTheSkyController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
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
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            checkPermissions()
        }
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
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
     //   myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
        
    }
    
}


// MARK: - Location Manager Delegate
extension EyeInTheSkyController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        adjustMap(with: coordinate)
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}
