//
//  APIClient.swift
//  NASAApp
//
//  Created by davidlaiymani on 12/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import Alamofire

// A class for the Alamofire request
class APIClient {
    
    typealias WebServiceResponse = (Data?, Error?) -> Void
    
    // Execute an URL request and return a JSON (Data) object or an Error object
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        
        Alamofire.request(url).validate().responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            } else {
                completion(response.data, nil)
            }
        }
    }
}

