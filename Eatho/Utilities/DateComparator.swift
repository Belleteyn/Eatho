//
//  DateComparator.swift
//  Eatho
//
//  Created by Серафима Зыкова on 18/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

class DateComparator {
    
    /**
     compares date with current day
     
     - returns
     0 if date is within 24 hours range with current time,
     1 if date is bigger more than 24 hours,
     -1 if date is less more than 24 hours
     */
    static func compareDateWithToday(date: Date) -> Int {
        let interval = date.timeIntervalSinceNow //in seconds
        let day = 24.0 * 60 * 60
        
        if interval > 0 {
            return 1
        } else if day + interval >= 0 {
            return 0
        } else {
            return -1
        }
    }
}
