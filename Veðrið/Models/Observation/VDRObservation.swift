//
//  VDRObservation.swift
//  Veðrið
//
//  Created by Ólafur Garðarsson on 06/11/15.
//  Copyright © 2015 Ólafur Garðarsson. All rights reserved.
//

import UIKit

class VDRObservation: NSObject {
    
    var stationName: String?;
    
    var time: NSDate?;
    var windSpeed: Double?;
    var windDirection: String?;
    var totalRain: Double?;
    var pressure: Double?;
    
    init(time: NSDate?, windSpeed: Double?, windDirection: String?, totalRain: Double?, pressure: Double?) {
        
        self.time = time;
        self.windSpeed = windSpeed;
        self.windDirection = windDirection;
        self.totalRain = totalRain;
        self.pressure = pressure;
    }
}
