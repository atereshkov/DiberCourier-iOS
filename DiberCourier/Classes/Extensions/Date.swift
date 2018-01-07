//
//  Date.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/7/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
}

extension Date {
    
    func toString() -> String {
        return DateFormatter.sharedDateFormatter.string(from: self)
    }
    
}
