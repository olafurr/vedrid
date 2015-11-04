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
        
        VDRWeatherAPI.sharedInstance.getWeather([1]).subscribeNext { result in
            if let forecasts = result {
                print(forecasts);
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

