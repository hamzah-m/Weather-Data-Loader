//
//  Day.swift
//  WeatherDataLoader
//
//  Created by Hamzah Mugharbil on 8/9/17.
//  Copyright © 2017 Hamzah Mugharbil. All rights reserved.
//

import Foundation

struct Day {
    
    var date: NSDate
    
    // arrays to hold all readings for day
    var windspeedReadings = [Double]()
    var barometricPressureReadings = [Double]()
    var airTemperatureReadings = [Double]()
    
    init(initialDate: NSDate) {
        self.date =  initialDate
    }
}
