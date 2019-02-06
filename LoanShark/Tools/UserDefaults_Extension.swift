//
//  UserDefaults_Extension.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

extension UserDefaults {
    func date(forKey key: String) -> Date? {
        guard let newDate = self.string(forKey: key) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let returnDate = formatter.date(from: newDate)
        return returnDate
    }
    
    func person(forKey key: String) -> Person? {
        guard let data = self.object(forKey: key) as? Data else {
            return nil
        }
        
        if #available(OSX 10.14, *) {
            return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Person
        }
        else {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
        }
    }
}
