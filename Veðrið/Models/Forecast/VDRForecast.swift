//
//  VDRForecast.swift
//  Veðrið
//
//  Created by Ólafur Garðarsson on 04/11/15.
//  Copyright © 2015 Ólafur Garðarsson. All rights reserved.
//

import Foundation

struct VDRForecast {
    var time: NSDate?;
    var windSpeed: NSNumber?;
    var windDirection: String?;
    var weatherDescription: String?;
    var totalRain: NSNumber?;
}
