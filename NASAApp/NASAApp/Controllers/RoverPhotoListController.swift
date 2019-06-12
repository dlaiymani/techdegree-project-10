//
//  RoverPhotoListController.swift
//  NASAApp
//
//  Created by davidlaiymani on 11/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RoverPhotoListController: UICollectionViewController {
    
    lazy var dataSource: RoverPhotoListDataSource = {
        return RoverPhotoListDataSource(collectionView: self.collectionView)
    }()
    
    private let roverAPIClient = APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = dataSource
        
        fetchRoverPhotos()

    }
    
    func fetchRoverPhotos() {
        
        guard let roverUrl = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2019-6-9&page=1&api_key=abONaFIip0FrAmEcZLiXbZqIUw2r7dOUPmRFWZMN") else {
            return
        }
        
        roverAPIClient.execute(roverUrl) { (jsonData, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let jsonData = jsonData {
                    let decoder = JSONDecoder()
                    //let jsonDict = json[0]["photos"] as! [Any]
                    let photos = try! decoder.decode([String: [RoverPhoto]].self, from: jsonData)
                    let roverPhotos = photos["photos"]!
                    self.dataSource.updateData(roverPhotos)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let cell = sender as? RoverPhotoCell, let indexPath = self.collectionView.indexPath(for: cell), let postalCardViewController = segue.destination as? PostalCardController {
           // postalCardViewController.roverImageView.image = cell.photoView.image
            postalCardViewController.roverPhoto = dataSource.object(at: indexPath)
        }
        
    }
}

    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

