//
//  ViewController.swift
//  NASAApp
//
//  Created by davidlaiymani on 11/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

// The main controller
class MainViewController: UIViewController {
    
    @IBOutlet weak var roverButton: UIButton!
    @IBOutlet weak var eyeInTheSkyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        

    }
    
}

