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
import AlamofireImage

class RoverPhotoListDataSource: NSObject, UICollectionViewDataSource {
    
    private var data = [RoverPhoto]()
    private let collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverPhotoCell.reuseIdentifier, for: indexPath) as! RoverPhotoCell
        
        let photo = data[indexPath.row]
        
        let url = URL(string: photo.roverImageSource)
       // print(url)

        Alamofire.request(url!).responseImage { response in
            if let image = response.result.value {
                DispatchQueue.main.async {
                    photoCell.photoView.image = image
                    self.data[indexPath.row].roverImage = image
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
    
    
}
