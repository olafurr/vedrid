//
//  WeatherItem.swift
//  Veðrið
//
//  Created by Ólafur Garðarsson on 06/11/15.
//  Copyright © 2015 Ólafur Garðarsson. All rights reserved.
//

import Foundation

struct VDRWeatherItem {
    
    
    var time: NSDate?;
    var windSpeed: Double?;
    var windDirection: String?;
    var weatherDescription: String?;
    var totalRain: Double?;
    
    
    init(time: NSDate?, windSpeed: Double?, windDirection: String?, weatherDescription: String?, totalRain: Double?) {
        
        self.time = time;
        self.windSpeed = windSpeed;
        self.windDirection = windDirection;
        self.weatherDescription = weatherDescription;
        self.totalRain = totalRain;
    }
}
