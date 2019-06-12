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
    var roverImage: UIImage?
    let photoDate: String
    
    enum RoverPhotoCodingKeys: String, CodingKey {
        case id
        case img_src
        case earth_date
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: RoverPhotoCodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.roverImageSource = try container.decode(String.self, forKey: .img_src)
        self.photoDate = try container.decode(String.self, forKey: .earth_date)
        self.roverImage = nil
    }
    
}
