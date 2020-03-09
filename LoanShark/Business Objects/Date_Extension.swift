//
//  Date_Extension.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

extension Date {
    
    /**
     Calculates the years between the current date and the date provided.
     - parameter from: The current date difference from.
     - Returns: The number of years difference from this date object and the date object provided as Int
     */
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    /**
    Calculates the months between the current date and the date provided.
    - parameter from: The current date difference from.
    - Returns: The number of months difference from this date object and the date object provided as Int
    */
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /**
    Calculates the weeks between the current date and the date provided.
    - parameter from: The current date difference from.
    - Returns: The number of weeks difference from this date object and the date object provided as Int
    */
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    /**
    Calculates the days between the current date and the date provided.
    - parameter from: The current date difference from.
    - Returns: The number of days difference from this date object and the date object provided as Int
    */
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /**
    Calculates the hours between the current date and the date provided.
    - parameter from: The current date difference from.
    - Returns: The number of hours difference from this date object and the date object provided as Int
    */
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /**
    Calculates the minutes  between the current date and the date provided.
    - parameter from: The current date difference from.
    - Returns: The number of minutes  difference from this date object and the date object provided as Int
    */
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /**
    Calculates the seconds  between the current date and the date provided.
    - parameter from: The current date difference from.
    - Returns: The number of seconds difference from this date object and the date object provided as Int
    */
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /**
    Calculates the nanoseconds between the current date and the date provided.
    - parameter from: The current date difference from.
    - Returns: The number of nanoseconds difference from this date object and the date object provided as Int
    */
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
    
    /**
    Turns the current date into a readable text using the provided format.
    - parameter format: The date format which is wanted to be used.
    - Returns: The current date object in a String form.
    */
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
