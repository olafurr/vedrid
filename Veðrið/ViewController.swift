//
//  ViewController.swift
//  Veðrið
//
//  Created by Ólafur Garðarsson on 03/11/15.
//  Copyright © 2015 Ólafur Garðarsson. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        VDRWeatherAPI.sharedInstance.getObservation([1]).start { data in
            if data.error != nil {
                print("Error: " + (data.error?.localizedDescription)!);
            } else {
                print(data.value);
            }
        }
        

    }
}

