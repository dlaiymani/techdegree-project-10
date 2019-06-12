//
//  RoverPhoto.swift
//  NASAApp
//
//  Created by davidlaiymani on 12/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit

struct RoverPhoto: Decodable {
    
    let id: Int
    let roverImageSource: String
    let roverImage: UIImage?
    let photoDate: String
    
    enum RoverPhotoCodingKeys: String, CodingKey {
        case id
        case img_src
        case earth_date
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: RoverPhotoCodingKeys.self)
        guard let id = container.codingPath.first else {
            let context = DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "RoverPhoto key not found")
            throw DecodingError.keyNotFound(RoverPhotoCodingKeys.id, context)
        }
        self.id = id.intValue!
        
        self.roverImageSource = try container.decode(String.self, forKey: .img_src)
        self.photoDate = try container.decode(String.self, forKey: .earth_date)
        self.roverImage = nil
    }
    
}
