//
//  PostalCardController.swift
//  NASAApp
//
//  Created by davidlaiymani on 12/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit
import MessageUI

class PostalCardController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var roverPhoto: RoverPhoto? // The RoverPhoto to display
    
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet var colorButtons: [UIButton]!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextFieldConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.delegate = self
        
        // Detect if the keyboeard is shown in order to adjust the view layout
        NotificationCenter.default.addObserver(self, selector: #selector(PostalCardController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostalCardController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let roverPhoto = roverPhoto {
            roverImageView.image = roverPhoto.roverImage
            userLabel.text = "Greetings From Mars"
            for button in colorButtons {
                button.layer.cornerRadius = button.frame.width/2
                button.layer.masksToBounds = true
            }
        }
    }
    
    // Sync the photo label while the user is tapping
    @IBAction func userTextValueChanged(_ sender: UITextField) {
        userLabel.text = sender.text
    }
    
    // Change the color of the text on the postal card
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
        userLabel.pulsate()

    }
    
    
    // Share by email
    @IBAction func sharedButtonTapped(_ sender: UIButton) {
        
        // get a new image with the text inserted
        let newImage = addTextToImage(text: userText.text!, inImage: roverImageView.image!, atPoint: CGPoint(x: 0, y: 0))
        roverImageView.image = newImage
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["laiymani@mac.com"])
            mail.setSubject("Greetings From Mars")
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            let imageData: Data = newImage!.pngData()!
            mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "PostalCard.png")
            
            present(mail, animated: true)
        } else {
            // show failure alert
            self.showAlert(withTitle: "Unable to send mail", message: "Please see your mail settings")
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    
    // Add the text label to the image
    func addTextToImage(text: String, inImage: UIImage, atPoint:CGPoint) -> UIImage? {
    
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)
        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        // Our drawing bounds
        let drawingBounds = CGRect(x: 0.0, y: 0.0, width: inImage.size.width, height: inImage.size.height)
        let font = self.userLabel.font
        let color = self.userLabel.textColor
        
        
        let attributes = font != nil ? [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : color] : [:]
        let textWidth = text.size(withAttributes: attributes as [NSAttributedString.Key : Any]).width
        let textHeight = text.size(withAttributes: attributes as [NSAttributedString.Key : Any]).height
       
        let textRect = CGRect(x: drawingBounds.size.width/2 - textWidth/2, y: drawingBounds.size.height/2 - textHeight/2,
                              width: textWidth, height: textHeight)
        
        userLabel.text = ""
        text.draw(in: textRect, withAttributes: attributes as [NSAttributedString.Key : Any])

        // Get the image from the graphics context
        let newImag = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImag
    }
    
    
    // MARK: - Keyboard Management
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let frame = keyboardFrame.cgRectValue
            
            if UIApplication.shared.statusBarOrientation.isLandscape {
                bottomTextFieldConstraint.constant = frame.size.height - 20
            } else {
                bottomTextFieldConstraint.constant = frame.size.height - 20
            }
        
            UIView.animate(withDuration: 0.8) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomTextFieldConstraint.constant = 30
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PostalCardController: UITextFieldDelegate {
    
    // When return is tapped the photo text is animated
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userLabel.pulsate()
        self.userText.resignFirstResponder()
        return true
    }
}
