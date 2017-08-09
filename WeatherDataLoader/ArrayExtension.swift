//
//  ArrayExtension.swift
//  WeatherDataLoader
//
//  Created by Hamzah Mugharbil on 8/9/17.
//  Copyright © 2017 Hamzah Mugharbil. All rights reserved.
//

import Foundation

extension Array {
    
    func calculateMean() -> Double {
        // is this an array of Doubles?
        if self.first is Double {
            // cast for "generic" array to typed array of Doubles
            let doubleArray = self.map { $0 as! Double }
            
            // use Swift "reduce" function to add all values together
            let total = doubleArray.reduce(0.0, {$0 + $1})
            
            let meanValue = total/Double(self.count)
            
            return meanValue
            
        } else {
            return Double.nan
        }
    }
    
    func calculateMedian() -> Double {
        // is this an array of Doubles?
        if self.first is Double {
            // cast for "generic" array to typed array of Doubles
            let doubleArray = self.map { $0 as! Double }
            
            // sort the array
            doubleArray.sorted(by: {$0 < $1})
            
            var medianValue: Double
            if doubleArray.count % 2 == 0 {
                // even number of elements, then the mean is the middle two elements
                let halfWay = doubleArray.count/2
                medianValue = (doubleArray[halfWay] + doubleArray[halfWay-1])/2
            } else {
                // odd number of elements, then just get the middle element
                medianValue = doubleArray[doubleArray.count/2]
            }
            
            return medianValue
            
        } else {
            return Double.nan
        }
    }
    
}
