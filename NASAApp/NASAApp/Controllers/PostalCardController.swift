//
//  PostalCardController.swift
//  NASAApp
//
//  Created by davidlaiymani on 12/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class PostalCardController: UIViewController {
    
    var roverPhoto: RoverPhoto?
    
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let roverPhoto = roverPhoto {
           print(roverPhoto.roverImage?.size)
            roverImageView.image = roverPhoto.roverImage
            userLabel.text = roverPhoto.photoDate
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
