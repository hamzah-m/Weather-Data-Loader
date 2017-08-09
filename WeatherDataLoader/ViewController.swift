//
//  ViewController.swift
//  WeatherDataLoader
//
//  Created by Hamzah Mugharbil on 8/9/17.
//  Copyright © 2017 Hamzah Mugharbil. All rights reserved.
//

import Cocoa
import CloudKit

class ViewController: NSViewController {

    @IBAction func saveData(_ sender: Any) {
        
        let arrayOfDays = collapseToSingleDays(year: "2012")
        saveDaysIntoCloudKit(oneYear: arrayOfDays)
    }
    
    func saveDaysIntoCloudKit(oneYear: [Day]) {
        
        // get our CloudKit container and Public Database
        let myContainer = CKContainer.default()
        let publicDatabase = myContainer.publicCloudDatabase
        
        // create an array of CloudKit records to save a batch
        var cloudRecords = [CKRecord]()
        
        // go through array of Day objects
        for singleDay in oneYear {
            // create CKRecord, give it a "type"
            let weatherRecord = CKRecord(recordType: "weatherData")
            
            // fill the new CKRecord with key/value pairs
            weatherRecord.setObject(singleDay.date, forKey: "date")
            
            weatherRecord.setObject(singleDay.windspeedReadings.calculateMean() as CKRecordValue, forKey: "windspeedMean")
            weatherRecord.setObject(singleDay.windspeedReadings.calculateMedian() as CKRecordValue, forKey: "windspeedMedian")
            weatherRecord.setObject(singleDay.airTemperatureReadings.calculateMean() as CKRecordValue, forKey: "airTemperatureMean")
            weatherRecord.setObject(singleDay.airTemperatureReadings.calculateMedian() as CKRecordValue, forKey: "airTemperatureMedian")
            weatherRecord.setObject(singleDay.barometricPressureReadings.calculateMean() as CKRecordValue, forKey: "barometricPressureMean")
            weatherRecord.setObject(singleDay.barometricPressureReadings.calculateMedian() as CKRecordValue, forKey: "barometricPressureMedian")
            
            // save new CKRecord into the array
            cloudRecords.append(weatherRecord)
            
        }
        
        print("There are \(cloudRecords.count) records about to be saved...")
        
        // create operation to save the records
        let operation = CKModifyRecordsOperation(recordsToSave: cloudRecords, recordIDsToDelete: nil)
        
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if error != nil {
                print("There was an error \(error.debugDescription)")
            } else {
                print("Saved \(savedRecords!.count) records into CloudKit")
            }
        }
        
        // run the operation
        publicDatabase.add(operation)
        
    }
    
    // collapses files into single days - 365 days for each year
    func collapseToSingleDays(year: String) -> [Day] {
        // create array to hold 365 Day structs
        var daysArray = [Day]()
        
        // get file path of a text file
        let path = Bundle.main.path(forResource: year, ofType: "txt")
        
        // read the text file into a string
        let fullText = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        // break string into an array of individual readings
        let readings = fullText!.components(separatedBy: "\n") as [String]!
        
        // create and configure a date formatter to convert from String to Date
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "PST") as TimeZone!
        formatter.dateFormat = "yyyy_MM_dd"
        
        // go through array of readings
        for i in 1..<readings!.count {
            
            // create a new array for each reading, break apart by tab
            let weatherData = readings![i].components(separatedBy: "\t")
            
            // first element is a date + time string
            let dateTime = weatherData[0]
            
            // strip down to get just the date
            let justDate = dateTime.substring(to: dateTime.index(dateTime.startIndex, offsetBy: 10))
            
            // convert from String to Date
            let dateOfCurrentReading = formatter.date(from: justDate)
            
            // get weather values and convert them from strings to doubles
            let temperatureValue = NumberFormatter().number(from: weatherData[1])!.doubleValue
            let pressureValue =  NumberFormatter().number(from: weatherData[2])!.doubleValue
            let windspeedValue =  NumberFormatter().number(from: weatherData[7])!.doubleValue
            
            // Check array of Days - if empty, or the most recent Day
            // is different from the current reading, create a new Day struct
            if daysArray.count == 0 || (daysArray[daysArray.count-1].date as Date != dateOfCurrentReading) {
                // create a new Day struct and add to array of Days
                let newDay = Day(initialDate: dateOfCurrentReading! as NSDate)
                daysArray.append(newDay)
            }
            
            // add current readings to latest "Day"
            daysArray[daysArray.count - 1].barometricPressureReadings.append(pressureValue)
            daysArray[daysArray.count - 1].airTemperatureReadings.append(temperatureValue)
            daysArray[daysArray.count - 1].windspeedReadings.append(windspeedValue)
            
        }
        return daysArray
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

