//
//  APIClient.swift
//  NASAApp
//
//  Created by davidlaiymani on 12/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import Alamofire


class APIClient {
    
    typealias WebServiceResponse = (Data?, Error?) -> Void
    
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


//Alamofire.request(.GET, "http://\(platform).eposapi.co.uk/?app_id=\(apiID)&app_key=\(apikey)&request=&request=gallery", parameters: nil)
//    .responseJSON { response in
//        print(response.request)  // original URL request
//        print(response.response) // URL response
//        print(response.data)     // server data
//        print(response.result)   // result of response serialization
//
//        if let JSON = response.result.value {
//            print("JSON: \(JSON)")
//
//            self.imageData = JSON as! Array<AnyObject>
//            print(self.imageData)
//            print("total number of images = \(self.imageData.count)")
//            for image in self.imageData{
//                print(image)
//            }
//
//
//
//}
