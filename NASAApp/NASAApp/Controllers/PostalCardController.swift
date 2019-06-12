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
    
    func addTextToImage(text: String, inImage: UIImage, atPoint:CGPoint) -> UIImage? {
    
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)
        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        // Our drawing bounds
        let drawingBounds = CGRect(x: 0.0, y: 0.0, width: inImage.size.width, height: inImage.size.height)
        
        let font = UIFont(name: "Snell Roundhand Bold", size: 30.0)
        let textFontAttributes = [
            NSAttributedString.Key.font: font
        ]
        
        let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
        let textWidth = text.size(withAttributes: attributes).width
        let textHeight = text.size(withAttributes: attributes).height
        
        let textRect = CGRect(x: drawingBounds.size.width/2 - textWidth/2, y: drawingBounds.size.height/2 - textHeight/2,
                              width: textWidth, height: textHeight)
        
        text.draw(in: textRect, withAttributes: attributes)
        // Get the image from the graphics context
        let newImag = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImag
    }

}

extension PostalCardController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userText.resignFirstResponder()

        let newImage = addTextToImage(text: userText.text!, inImage: roverImageView.image!, atPoint: CGPoint(x: 0, y: 0))
        roverImageView.image = newImage
        return true
    }
    

    
}
