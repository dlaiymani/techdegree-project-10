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
    
    var picker : UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    var dateToSearch = Date().dayBefore.dayBefore
    
    lazy var dataSource: RoverPhotoListDataSource? = {
        return RoverPhotoListDataSource(collectionView: self.collectionView, viewController: self as UIViewController)
    }()
    
    private let roverAPIClient = APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = dataSource
        
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.maximumDate = Date().dayBefore
        picker.addTarget(self, action: #selector(newDate), for: UIControl.Event.touchUpInside)

        fetchRoverPhotos()

    }
    
    func fetchRoverPhotos() {
        
        let stringDate = dateToSearch.stringFromDate()
        self.navigationItem.title = stringDate
        
        guard let roverUrl = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=\(stringDate)&page=1&api_key=abONaFIip0FrAmEcZLiXbZqIUw2r7dOUPmRFWZMN") else {
            return
        }

        activityController.startAnimating()
        roverAPIClient.execute(roverUrl) { (jsonData, error) in
            if let error = error {
                self.showAlert(withTitle: "Network error", message: error.localizedDescription)
            } else {
                if let jsonData = jsonData {
                    let decoder = JSONDecoder()
                    
                    if let photos = try? decoder.decode([String: [RoverPhoto]].self, from: jsonData) {
                    let roverPhotos = photos["photos"]!
                        if roverPhotos.count == 0 {
                            self.showAlert(withTitle: "No Photo", message: "Please try to change the date")
                        } else {
                            self.dataSource?.updateData(roverPhotos)
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.activityController.stopAnimating()
                            }
                        }
                    } else {
                        self.showAlert(withTitle: "JSON problem", message: "The server response is incorrect")

                    }
                }
            }
        }
    }
    
    @objc func newDate(_ sender: UIDatePicker) {
    }
    
    
    @IBAction func changeDate(_ sender: UIBarButtonItem) {
        
        if self.navigationItem.rightBarButtonItem?.title == "OK" {
            dateToSearch = picker.date
            self.navigationItem.rightBarButtonItem?.title = "Change Date"
            picker.isHidden = true

            fetchRoverPhotos()

            
        } else {
        
            picker.isHidden = false
            
            var pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
            //picker.frame = CGRect(x: 0.0, y: 250, width: pickerSize.width, height: 200)
            
            //picker.frame(forAlignmentRect: CGRect(x: 0.0, y: 250, width: pickerSize.width, height: 200))
            picker.backgroundColor = .white
            
            self.navigationItem.rightBarButtonItem?.title = "OK"
            
            self.picker.layer.cornerRadius = 15
            self.picker.layer.masksToBounds = true
            
            self.view.addSubview(picker)
            picker.translatesAutoresizingMaskIntoConstraints = false
            
            
            let widthConstraint = NSLayoutConstraint(item: picker, attribute: .width, relatedBy: .equal,
                                                     toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: pickerSize.width)
            
            let heightConstraint = NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal,
                                                      toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)
            
            let xConstraint = NSLayoutConstraint(item: picker, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            
            let yConstraint = NSLayoutConstraint(item: picker, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
            
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil {
            self.dataSource = nil        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? RoverPhotoCell, let indexPath = self.collectionView.indexPath(for: cell), let postalCardViewController = segue.destination as? PostalCardController {
           // postalCardViewController.roverImageView.image = cell.photoView.image
            postalCardViewController.roverPhoto = dataSource?.object(at: indexPath)
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

