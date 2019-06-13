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
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet var colorButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.delegate = self
        
        if let roverPhoto = roverPhoto {
           print(roverPhoto.roverImage?.size)
            roverImageView.image = roverPhoto.roverImage
            userLabel.text = roverPhoto.photoDate
            
            for button in colorButtons {
                button.layer.cornerRadius = button.frame.width/2
                button.layer.masksToBounds = true
            }
            
        }
    }
    
    
    @IBAction func userTextValueChanged(_ sender: UITextField) {
        userLabel.text = sender.text
    }
    
    @IBAction func colorChanged(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            userLabel.textColor = UIColor(red: 0.888, green: 0.375, blue: 0.366, alpha: 1.0)
        case 1:
            userLabel.textColor = UIColor(red: 0.0, green: 0.563, blue: 0.319, alpha: 1)
        case 2:
            userLabel.textColor = UIColor(red: 0, green: 0.590, blue: 1.0, alpha: 1)
        case 3:
            userLabel.textColor = UIColor(red: 1.0, green: 0.832, blue: 0.473, alpha: 1)
        case 4:
            userLabel.textColor = UIColor(red: 0.845, green: 0.515, blue: 1.0, alpha: 1)
        case 5:
                userLabel.textColor = .black
        default:
            userLabel.textColor = .black
        }
    }
    
    
    @IBAction func sharedButtonTapped(_ sender: UIButton) {
        
        let newImage = addTextToImage(text: userText.text!, inImage: roverImageView.image!, atPoint: CGPoint(x: 0, y: 0))
        roverImageView.image = newImage
        
        
        let shareViewController = UIActivityViewController(activityItems: [newImage, "hello"], applicationActivities: nil)

     //   let shareViewController = UIActivityViewController(activityItems: [newImage], applicationActivities: nil)
        present(shareViewController, animated: true, completion: nil)
        if let popOver = shareViewController.popoverPresentationController {
            popOver.sourceView = self.view
            popOver.barButtonItem = self.navigationItem.rightBarButtonItem;

           // popOver.sourceRect = popOver.barButtonItem
        }
    }
    
    
    func addTextToImage(text: String, inImage: UIImage, atPoint:CGPoint) -> UIImage? {
    
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)
        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        // Our drawing bounds
        let drawingBounds = CGRect(x: 0.0, y: 0.0, width: inImage.size.width, height: inImage.size.height)
        let font = self.userLabel.font
        let color = self.userLabel.textColor
        
        //let font = UIFont(name: "Snell Roundhand Bold", size: 30.0)
        
        let attributes = font != nil ? [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : color] : [:]
        let textWidth = text.size(withAttributes: attributes).width
        let textHeight = text.size(withAttributes: attributes).height
       
        
        let textRect = CGRect(x: drawingBounds.size.width/2 - textWidth/2, y: drawingBounds.size.height/2 - textHeight/2,
                              width: textWidth, height: textHeight)
        
        
        userLabel.text = ""
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
        
        return true
    }
    

    
}
