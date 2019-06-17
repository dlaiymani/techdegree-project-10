//
//  NASAAppTests.swift
//  NASAAppTests
//
//  Created by davidlaiymani on 17/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import XCTest
@testable import NASAApp

class NASAAppTests: XCTestCase {

    var roverAPIClient: APIClient!
    
    override func setUp() {
        super.setUp()
        roverAPIClient = APIClient()
    }

    func testValidCallToMarsRover() {
        let roverUrl = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2019-05-05&page=1&api_key=abONaFIip0FrAmEcZLiXbZqIUw2r7dOUPmRFWZMN")
        
        let promise = expectation(description: "Status code: 200")

        roverAPIClient.execute(roverUrl!) { (jsonData, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                if let jsonData = jsonData {
                    let decoder = JSONDecoder()
                    let photos = try! decoder.decode([String: [RoverPhoto]].self, from: jsonData)
                    let roverPhotos = photos["photos"]!
                    if roverPhotos.count == 0 {
                       // self.showAlert(withTitle: "No Photo", message: "Please try to change the date")
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
    
    override func tearDown() {
        roverAPIClient = nil
        super.tearDown()
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    

}
