//
//  DateExtension.swift
//  Cario
//
//  Created by Sinakhanjani on 7/22/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

extension Date {
    
    func loadHundredYear() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: .persian)
        dateFormatter.dateFormat = "yyyy"
        var todayYear = Int(dateFormatter.string(from: self))!
        var years = [String]()
        years.append(String(todayYear))
        for _ in 0..<60 {
            todayYear -= 1
            years.append(String(todayYear))
        }
        years = years.reversed()
        return years
    }
    
    func PersianDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: .persian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    func hourNow() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateAsString = dateFormatter.string(from: self)
        let date = dateFormatter.date(from: dateAsString)!
        dateFormatter.dateFormat = "HH"
        
        return Int(dateFormatter.string(from: date))!
    }
    
    func minuteInHourNow() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateAsString = dateFormatter.string(from: self)
        let date = dateFormatter.date(from: dateAsString)!
        dateFormatter.dateFormat = "mm"
        
        return Int(dateFormatter.string(from: date))!
    }
    
    static public func isExpired(date: String, time: String) -> Bool? {
        let dateFormatter = DateFormatter()
        let timeFormmater = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "fa_IR")
        dateFormatter.calendar = Calendar.init(identifier: .persian)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        timeFormmater.locale = Locale.init(identifier: "fa_IR")
        timeFormmater.calendar = Calendar.init(identifier: .persian)
        timeFormmater.dateFormat = "yyyy/MM/dd hh:mm:ss"
        guard let exDate = dateFormatter.date(from: date) else { return nil }
        let exdate_string = dateFormatter.string(from: exDate)
        let today_time = Date()
        guard let ex_time = timeFormmater.date(from: "\(exdate_string) \(time)") else { return nil }
        let today_time_type = timeFormmater.string(from: today_time)
        let change_time_expired = timeFormmater.string(from: ex_time)
        guard let exTime = timeFormmater.date(from: change_time_expired) else { return nil }
        guard let todayTime = timeFormmater.date(from: today_time_type) else { return nil }
        if exTime < todayTime {
            return true
        }
        return false
    }
    
    func openTime(provider: Provider, catId: String, splitHour: String) -> [String] {
        var times = [String]()
        let amStart = Int(provider.startWorkHour)!
        let amStop = Int(provider.endWorkHour)!

        for number in amStart..<amStop {
            times.append("\(number)")
        }
        var openTime = [String]()
        let hour = hourNow()
        let minute = minuteInHourNow()
        for time in times {
            let intTime = Int(time)!
            if intTime >= hour {
                openTime.append("\(intTime)")
            }
        }
        for (index,time) in openTime.enumerated() {
            if Int(time)! == hour {
                if minute >= 30 {
                    openTime.remove(at: index)
                }
            }
        }
        var labelTime = [String]()
        for time in openTime {
            labelTime.append("\(Int(time)!) الی \(Int(time)! + Int(splitHour)!)")
        }
        return labelTime
    }
    
    func openTimeWeek(provider: Provider, catId: String, splitHour: String) -> [String] {
        var openTimes = [String]()
        let amStart = Int(provider.startWorkHour)!
        let amStop = Int(provider.endWorkHour)!
        for number in amStart..<amStop {
            openTimes.append("\(number)")
        }
        var labelTime = [String]()
        for time in openTimes {
            labelTime.append("\(Int(time)!) الی \(Int(time)! + Int(splitHour)!)")
        }
        return labelTime
    }
    
    func openDate(maxDay: String) -> [String] {
        var dates = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: .persian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for i in 0..<Int(maxDay)! {
            let nextDayDate = self.addingTimeInterval(TimeInterval(60 * 60 * 24 * i))
            let nextDay = dateFormatter.string(from: nextDayDate)
            if i == 0 {
                // "امروز" + " | " + nextDay
                dates.append(nextDay)
            } else if i == 1 {
                // "فـردا" + " | " + nextDay
                dates.append(nextDay)
            } else {
                dates.append(nextDay)
            }
        }
        return dates
    }
    
    
}
