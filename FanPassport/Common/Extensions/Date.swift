//
//  Date.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//
import UIKit

extension Date {
    func getMonthYearLabel() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let lbl = dateFormatter.string(from: self)
        return lbl
    }
    
    func getDayMonthWeekdayLabel() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, EEEE"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let lbl = dateFormatter.string(from: self)
        return lbl
    }
    
    func getWeekdayLabel() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let lbl = dateFormatter.string(from: self)
        return lbl
    }
    
    func getDayMonthYearLabel() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let lbl = dateFormatter.string(from: self)
        return lbl
    }
    
    func getString(with format: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let lbl = dateFormatter.string(from: self)
        return lbl
    }
    
    //2015-02-04T00:00:00
    func getISODate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let lbl = dateFormatter.string(from: self)
        return lbl
    }
    
    func getHoursMinutes() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let lbl = dateFormatter.string(from: self)
        return lbl
    }
    
    var millisecondsSinceNow:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds))
    }
}
