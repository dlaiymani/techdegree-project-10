//
//  EarthPhoto.swift
//  NASAApp
//
//  Created by davidlaiymani on 13/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit

struct EarthPhoto: Decodable {
    
    let id: String
    let earthPhotoSource: String
    var earthPhotoImage: UIImage?
    let earthPhotoDate: String
    
    enum EarthPhotoCodingKeys: String, CodingKey {
        case id
        case url
        case date
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: EarthPhotoCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.earthPhotoSource = try container.decode(String.self, forKey: .url)
        self.earthPhotoDate = try container.decode(String.self, forKey: .date)
        self.earthPhotoImage = nil
    }
    
}
