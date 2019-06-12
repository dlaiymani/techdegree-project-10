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
        userText.delegate = self
        
        if let roverPhoto = roverPhoto {
           print(roverPhoto.roverImage?.size)
            roverImageView.image = roverPhoto.roverImage
            userLabel.text = roverPhoto.photoDate
            
            userLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)

        }
    }
    
    
    @IBAction func userTextValueChanged(_ sender: UITextField) {
        userLabel.text = sender.text
    }
    
    @IBAction func colorChanged(_ sender: Any) {
        switch colorSegmentedControl.selectedSegmentIndex {
        case 0:
            userLabel.textColor = .red
        case 1:
            userLabel.textColor = .blue
        case 2:
            userLabel.textColor = .green
        case 3:
            userLabel.textColor = .yellow
        default:
            userLabel.textColor = .black
        }
        
    }
    
}

extension PostalCardController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userText.resignFirstResponder()
        return true
    }
    

    
}
