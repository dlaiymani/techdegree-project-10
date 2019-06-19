//
//  Date+Extension.swift
//  NASAApp
//
//  Created by davidlaiymani on 14/06/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

// A set of date functions
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    
    func stringFromDate() -> String {
        let format       = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: self)
    }
    
}
