//
//  NASAAppLocationTests.swift
//  NASAAppLocationTests
//
//  Created by davidlaiymani on 17/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import XCTest
@testable import Pods_NASAApp
import CoreLocation

// Location Unit Tests
class NASAAppLocationTests: XCTestCase, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D!
    
    var locationPromise: XCTestExpectation!

    override func setUp() {
        self.locationManager.delegate = self
        locationPromise = expectation(description: "Get valid coordinates")
        
    }
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    func testValidCoordinateReturned() {
        
        XCTAssertNil(coordinate)
        requestLocation()
        wait(for: [locationPromise], timeout: 10)
        
    }
    
    // Location has changed so get the new coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        self.coordinate = location.coordinate
        locationPromise.fulfill()
    }
    

    override func tearDown() {
        coordinate = nil
        super.tearDown()
        
    }


}
