//
//  EyeInTheSkyController.swift
//  NASAApp
//
//  Created by davidlaiymani on 13/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit
import MapKit

class EyeInTheSkyController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.imageView.isHidden = true
    }

}


