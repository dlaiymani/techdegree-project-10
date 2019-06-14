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
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let dataSource = SearchAddressResultsDataSource()

    var request = MKLocalSearch.Request()
    var search: MKLocalSearch?
    
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
        self.setupTableView()
        self.setupSearchBar()

        
    }

    
    // MARK: - Table View
    func setupTableView() {
        self.tableView.isHidden = true
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
    
    // MARK: - Search
    func setupSearchBar() {
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for locations"
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            checkPermissions()
        }
    }
    
    
    @IBAction func clearAnnotations(_ sender: UIBarButtonItem) {
        
        if sender.title == "Cancel" {
            self.searchController.searchBar.text = ""
            self.tableView.isHidden = true
            self.navigationItem.rightBarButtonItem?.title = "Current Position"
            self.searchController.searchBar.endEditing(true)
            self.searchController.resignFirstResponder()
            self.searchController.searchBar.setNeedsLayout()
            
            self.dataSource.update(with: [])
            self.tableView.reloadData()

            
        } else {
            mapView.removeAnnotations(mapView.annotations)
            let coordinate = Coordinate(location: locationManager.currentLocation!.coordinate)
            adjustMap(with: coordinate)
            imageView.isHidden = true
            self.activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            fetchEarthPhoto(forCoordinate: coordinate)
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


extension EyeInTheSkyController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: create function 
        self.searchController.searchBar.text = ""
        self.tableView.isHidden = true
        self.navigationItem.rightBarButtonItem?.title = "Current Position"
        self.searchController.searchBar.endEditing(true)
        self.searchController.resignFirstResponder()
        self.searchController.searchBar.setNeedsLayout()

        let mapItem = dataSource.object(at: indexPath)
        let coordinate = Coordinate(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.coordinate = coordinate
        let address = Address(number: mapItem.placemark.subThoroughfare, street: mapItem.placemark.thoroughfare, postalCode: mapItem.placemark.postalCode, locality: mapItem.placemark.locality, country: mapItem.placemark.country, name: mapItem.placemark.name, coordinate: coordinate)
        self.adjustMap(with: coordinate)
        
        imageView.isHidden = true
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchEarthPhoto(forCoordinate: coordinate)
        
        self.dataSource.update(with: [])
        self.tableView.reloadData()
    }
    
//    didselectrow
//    tableView.isHidden = true
//    self.navigationItem.rightBarButtonItem?.isEnabled = false
    
}


extension EyeInTheSkyController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        
        if !searchTerm.isEmpty {
            search?.cancel()
            request.naturalLanguageQuery = searchTerm
            request.region = self.mapView.region
            
            search = MKLocalSearch(request: request)
            
            search!.start { (responses, error) in
                if let responses = responses {
                    DispatchQueue.main.async {
                        self.dataSource.update(with: responses.mapItems)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}


// SearchBar delegate
extension EyeInTheSkyController: UISearchBarDelegate {
    
    
    // When the user enter some text, the quick note view is dismissed
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //tableView.reloadData()
        tableView.isHidden = false
        self.navigationItem.rightBarButtonItem?.title = "Cancel"
        self.searchController.searchBar.setNeedsLayout()
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.dataSource.update(with: [])
//        self.tableView.reloadData()
//    }
    
    // Cross button tapped
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            dataSource.update(with: [])
            tableView.reloadData()
        }
    }
}
