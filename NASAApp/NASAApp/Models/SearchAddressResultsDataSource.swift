//
//  SearchAddressResultsDataSource.swift
//  NASAApp
//
//  Created by davidlaiymani on 14/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// This class is the data source for the searchbar in the location controller
// It allows to display the location results searched by the user
class SearchAddressResultsDataSource: NSObject, UITableViewDataSource {
    
    private var data = [MKMapItem]()
    
    override init() {
        super.init()
    }
    
    // MARK: Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        
        let mapItem = object(at: indexPath)
        
        let coordinate = Coordinate(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
        let address = Address(number: mapItem.placemark.subThoroughfare, street: mapItem.placemark.thoroughfare, postalCode: mapItem.placemark.postalCode, locality: mapItem.placemark.locality, country: mapItem.placemark.country, name: mapItem.placemark.name, coordinate: coordinate)
        
        cell.textLabel?.text = address.addressString()
        cell.detailTextLabel?.text = address.completeAddressString()
        
        return cell
    }
    
    
    // MARK: Helpers
    
    func object(at indexPath: IndexPath) -> MKMapItem {
        return data[indexPath.row]
    }
    
    func update(with data: [MKMapItem]) {
        self.data = data
    }
    
    func update(_ object: MKMapItem, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
}
