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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = dataSource

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

}
