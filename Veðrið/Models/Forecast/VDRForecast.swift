//
//  VDRForecast.swift
//  Veðrið
//
//  Created by Ólafur Garðarsson on 04/11/15.
//  Copyright © 2015 Ólafur Garðarsson. All rights reserved.
//

import Foundation

struct VDRForecast {
    
    var forecastItems: [VDRWeatherItem]?;
    var stationName: String?;
    
    init(items: [VDRWeatherItem]?, stationName: String?) {
        self.forecastItems = items;
        self.stationName = stationName;
    }

    
}
