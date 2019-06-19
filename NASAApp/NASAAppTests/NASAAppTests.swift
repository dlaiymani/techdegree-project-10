//
//  NASAAppTests.swift
//  NASAAppTests
//
//  Created by davidlaiymani on 17/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import XCTest
@testable import NASAApp
@testable import Alamofire
import CoreLocation

// NASA API Unit Tests (Rover and Earth)
class NASAAppTests: XCTestCase {

    var NASAAPIClient: APIClient!

    
    override func setUp() {
        super.setUp()
        NASAAPIClient = APIClient()
        
    }

    // Test if the call to Mars Rover API is valid
    func testValidCallToMarsRover() {
        let roverUrl = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2019-05-05&page=1&api_key=abONaFIip0FrAmEcZLiXbZqIUw2r7dOUPmRFWZMN")
        
        let promise = expectation(description: "Hitting Mars Rover API")

        NASAAPIClient.execute(roverUrl!) { (jsonData, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                if let jsonData = jsonData {
                    let decoder = JSONDecoder()
                    let photos = try! decoder.decode([String: [RoverPhoto]].self, from: jsonData)
                    let roverPhotos = photos["photos"]!
                    if roverPhotos.count == 0 {
                        XCTFail("Error: No Photo")
                    } else {
                      promise.fulfill()
                    }
                } else {
                   XCTFail("Error: Bad JSON format")
                }
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    // Test if the call to Mars Rover Photo API is valid
    func testValidCallToMarsRoverPhoto() {
        let url = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/02432/opgs/edr/fcam/FLB_613396226EDR_F0760274FHAZ00302M_.JPG" )
        
        let promise = expectation(description: "Hitting Mars Rover Photo ")

        
        Alamofire.request(url!).responseImage { response in
            if let error = response.error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                if response.result.value != nil {
                    promise.fulfill()
                }
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    
    func testValidCallToEarthView() {
        // The Eiffel Tower
        let coordinate = Coordinate(latitude: 48.858370, longitude: 2.294481)
        let url = URL(string: "https://api.nasa.gov/planetary/earth/imagery/?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&api_key=abONaFIip0FrAmEcZLiXbZqIUw2r7dOUPmRFWZMN")
        
        let promise = expectation(description: "Hitting Earth Imagery Photo ")
        
        NASAAPIClient.execute(url!) { (jsonData, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                
            } else {
                if let jsonData = jsonData {
                    let decoder = JSONDecoder()
                    if (try? decoder.decode(EarthPhoto.self, from: jsonData)) != nil {
                        promise.fulfill()
                    } else {
                        XCTFail("Error: JSON problem")
                    }
                }
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
   
    
    
    
    override func tearDown() {
        NASAAPIClient = nil
        super.tearDown()
    }

    

}
