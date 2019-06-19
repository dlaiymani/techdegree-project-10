//
//  RoverPhotoCell.swift
//  NASAApp
//
//  Created by davidlaiymani on 11/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

// The cell view of the RoverPhoto CollectionView
class RoverPhotoCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: RoverPhotoCell.self)
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
