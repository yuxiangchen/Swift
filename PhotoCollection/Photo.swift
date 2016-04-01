//
//  Photo.swift
//  PhotoCollection
//
//  Created by Dale Musser on 10/19/15.
//  Copyright © 2015 Swift Developer Academy. All rights reserved.
//

import Foundation

class Photo {
    var fileName: String = ""
    var title: String = ""
    var description: String = ""
    var latitude: Double
    var longitude: Double
    var date: NSDate
    //This is an constructor in switf... initilizer
    init(fileName: String, title: String, description: String, latitude: Double, longitude: Double, dateString: String) {
        self.fileName = fileName
        self.title = title
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.dateFromString(dateString) {
            self.date = date
        } else {
            //gives the current time right now.
            self.date = NSDate(timeIntervalSinceNow: 0)
        }
    }
    
}