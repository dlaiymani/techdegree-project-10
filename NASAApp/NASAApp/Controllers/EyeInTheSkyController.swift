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
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    
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
    
    
    var coordinate: Coordinate? // The curent coordinates
    
    // Check if location authorizations are ok
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
    
    // Get current location of the device and fetch the corresponding photo
    // or cancel the search for location
    @IBAction func getCurrentLocation(_ sender: UIBarButtonItem) {
        
        if sender.title == "Cancel" { // Cancel the search in the search bar controller
            self.searchController.searchBar.text = ""
            self.tableView.isHidden = true
            self.navigationItem.rightBarButtonItem?.title = "Current Position"
            self.searchController.searchBar.endEditing(true)
            self.searchController.resignFirstResponder()
            self.searchController.searchBar.setNeedsLayout()
            
            self.dataSource.update(with: [])
            self.tableView.reloadData()

        } else { // get the current location and fetch the corresponding photo
            locationManager.requestLocation()
            mapView.removeAnnotations(mapView.annotations)
            let coordinate = Coordinate(location: locationManager.currentLocation!.coordinate)
            adjustMap(with: coordinate)
            imageView.isHidden = true
            self.activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            fetchEarthPhoto(forCoordinate: coordinate)
        }

    }
    
    // If the user tapped onto the map, get the associated coordinates
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            let locationInView = sender.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView , toCoordinateFrom: mapView)
            addAnnotation(coordinate: tappedCoordinate)
            let coordinate = Coordinate(location: tappedCoordinate)
            self.obtainedCoordinates(coordinate)
        }
    }
    
    // Add an annotation onto the map at specific coordinates
    func addAnnotation(coordinate:CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    // Chekc the location authorization
    func checkPermissions() {
        do {
            try locationManager.requestLocationAuthorization()
        } catch LocationError.disallowedByUser {
            self.showAlert(withTitle: "ReminderApp needs your location data", message: "Please, see your settings configuration")
        } catch let error {
            print("Location Authorization error \(error.localizedDescription)")
        }
    }
    
    
    // Adjust the map around some coordinates
    func adjustMap(with coordinate: Coordinate) {
        let coordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion.init(center: coordinate2D, latitudinalMeters: 2500, longitudinalMeters: 2500)
        
        mapView.setRegion(region, animated: true)
        addAnnotation(coordinate: CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))
    }
    
    
    // Fecth the earth photo for some given coordinates by using the NASA API
    func fetchEarthPhoto(forCoordinate coordinate: Coordinate) {
        
        let urlString = "https://api.nasa.gov/planetary/earth/imagery/?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&api_key=abONaFIip0FrAmEcZLiXbZqIUw2r7dOUPmRFWZMN"
        
        guard let roverUrl = URL(string: urlString) else {
            return
        }
        
        earthPhotoAPIClient.execute(roverUrl) { (jsonData, error) in
            if let error = error {
                self.showAlert(withTitle: "Network Problem", message: error.localizedDescription)
            } else {
                if let jsonData = jsonData {
                    let decoder = JSONDecoder()
                    
                    if let photo = try? decoder.decode(EarthPhoto.self, from: jsonData) {
                        DispatchQueue.main.async {
                            self.displayPhoto(url: photo.earthPhotoSource)
                        }
                    } else {
                        self.showAlert(withTitle: "JSON problem", message: "The server response is incorrect")
                    }
                }
            }
        }
    }
    
    // Display the photo associated with a given URL
    func displayPhoto(url: String) {
        Alamofire.request(url).responseImage { response in
            
            if let error = response.error {
                self.showAlert(withTitle: "Network Problem", message: error.localizedDescription)
            } else {
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
}



// MARK: - Location Manager Delegate

extension EyeInTheSkyController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        adjustMap(with: coordinate)
        self.activityIndicator.isHidden = false
        imageView.isHidden = true
        activityIndicator.startAnimating()
        fetchEarthPhoto(forCoordinate: coordinate)
    }
    
    func failedWithError(_ error: LocationError) {
        let alertError = AlertError(error: error, on: self)
        alertError.displayAlert()
    }
}


// MARK: - UITableView Delegate for the UISearchController

extension EyeInTheSkyController: UITableViewDelegate {
    // When a location is choosen by the user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
       // let address = Address(number: mapItem.placemark.subThoroughfare, street: mapItem.placemark.thoroughfare, postalCode: mapItem.placemark.postalCode, locality: mapItem.placemark.locality, country: mapItem.placemark.country, name: mapItem.placemark.name, coordinate: coordinate)
        self.adjustMap(with: coordinate)
        
        imageView.isHidden = true
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchEarthPhoto(forCoordinate: coordinate)
        
        self.dataSource.update(with: [])
        self.tableView.reloadData()
    }
}


// MARK: - UISearchResultsUpdating Delegate

extension EyeInTheSkyController: UISearchResultsUpdating {
    
    // When the user is tapping in the SearchBar, use the MKLocalSearch API to implement geocoding
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        
        if !searchTerm.isEmpty {
            tableViewActivityIndicator.startAnimating()
            search?.cancel()
            request.naturalLanguageQuery = searchTerm
            request.region = self.mapView.region
            
            search = MKLocalSearch(request: request)
            
            search!.start { (responses, error) in
                if let responses = responses {
                    DispatchQueue.main.async {
                        self.dataSource.update(with: responses.mapItems)
                        self.tableView.reloadData()
                        self.tableViewActivityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate Delegate

extension EyeInTheSkyController: UISearchBarDelegate {
    
    // When the user enter some text, the quick note view is dismissed
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        self.navigationItem.rightBarButtonItem?.title = "Cancel"
        self.searchController.searchBar.setNeedsLayout()
    }
    
    // Cross button tapped
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            dataSource.update(with: [])
            tableView.reloadData()
        }
    }
}
