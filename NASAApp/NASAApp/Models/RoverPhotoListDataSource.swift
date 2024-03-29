//
//  RoverPhotoListDataSource.swift
//  NASAApp
//
//  Created by davidlaiymani on 12/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

// The CollectionView DataSource for the list of Rover photos
class RoverPhotoListDataSource: NSObject, UICollectionViewDataSource {
    
    private var data = [RoverPhoto]()
    private let collectionView: UICollectionView
    private let viewController: UIViewController
    
    init(collectionView: UICollectionView, viewController: UIViewController) {
        self.collectionView = collectionView
        self.viewController = viewController
        super.init()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    // A cell is the rover image associated with a RoverPhoto object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverPhotoCell.reuseIdentifier, for: indexPath) as! RoverPhotoCell
        
        let photo = data[indexPath.row]
        
        let url = URL(string: photo.roverImageSource)

        // Get the associated photo
        photoCell.activityIndicator.startAnimating()
        Alamofire.request(url!).responseImage { response in
            if let error = response.error {
                self.viewController.showAlert(withTitle: "Network Problem", message: error.localizedDescription)
            } else {
                if let image = response.result.value {
                    DispatchQueue.main.async {
                        photoCell.photoView.image = image
                        self.data[indexPath.row].roverImage = image
                        photoCell.activityIndicator.stopAnimating()

                    }
                }
            }
        }
        return photoCell
    }
    
    // MARK: - Helpers
    func updateData(_ data: [RoverPhoto]) {
        self.data = data
    }
    
    func object(at indexPath: IndexPath) -> RoverPhoto {
        return self.data[indexPath.row]
    }
    
    deinit {
    }
}
