//
//  Date.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation


extension Date{
    
    func toNiceLabel() -> String{
        if self.isToday(){
            return "Oggi"
        }
        return self.toLabel()
    }
    
    func isToday() -> Bool{
        return self.midnightUTCDate() == Date().midnightUTCDate()
    }
    
    func toLabel() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toLongLabel() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: DeviceManager.getLang().rawValue)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func hourLabel() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func yyyyMMdd() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
    
    func formatGPDate(daysOffset: Int) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        // Estrai giorno iniziale
        dateFormatter.dateFormat = "d" // Solo il giorno
        let startDay = dateFormatter.string(from: self)
        
        // Calcola la data finale
        guard let endDate = calendar.date(byAdding: .day, value: daysOffset, to: self) else {
            return "Errore nel calcolo della data"
        }
        
        let endDay = dateFormatter.string(from: endDate)
        
        // Ottieni il mese in maiuscolo
        dateFormatter.dateFormat = "MMM" // Mese abbreviato
        dateFormatter.locale = Locale(identifier: DeviceManager.getLang().rawValue)  // Italiano
        let month = dateFormatter.string(from: endDate).uppercased() // Uppercase per il mese
        return "\(startDay)-\(endDay) \(month)"
    }
    func yyyyMMddHHmmss() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func niceLabelAndHours() -> String{
        guard let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) else {
            return ""
        }
        
        if dateFormat.firstIndex(of: "a") != nil {
            var dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: DeviceManager.getLang().rawValue)
            dateFormatter.dateFormat = "dd MMMM yyyy - h:mm a"
            let p = dateFormatter.string(from: self)
            return p
        }

        let dateFormatters = DateFormatter()
        dateFormatters.locale = Locale(identifier: DeviceManager.getLang().rawValue)
        dateFormatters.dateFormat = "dd MMMM yyyy - HH:mm"
        let p = dateFormatters.string(from: self)
        
        return p
    }
    
    //function to store milliseconds to firebase
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    //function to convert firebase milliseconds to date
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    init(date: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        self = dateFormatter.date(from: date) ?? Date(milliseconds: 0) // nil
    }
    
    func jsonData() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
    
    public func midnightUTCDate(_ removeLocalUTC : Bool  = false) -> Date {
        var calendar = Calendar.current
        if removeLocalUTC
        {
            if let timeZone = TimeZone(secondsFromGMT: 0) {
                calendar.timeZone = timeZone
            }
        }
        var dc: DateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: 0)
        return calendar.date(from: dc)!
    }
    
}

extension Date {
    
    func days(to date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(to date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: self, to: date).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(to date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: self, to: date).minute ?? 0
    }
    
    var remainingTime: (g: Int,h: Int,m: Int){
        let startDate = self
        let days = Date().days(to: startDate)
        let hours = Date().hours(to: startDate)
        let min = Date().minutes(to: startDate)
        return (g: days, h:hours, m: min)
    }
    
    func remainTimeFrom(date: Date?) -> String {
        if let result = date?.remainingTime{
            let d = result.g
            let h = result.h - 24*d
            let m = result.m - 60*24*d - h*60
            
            var returnString = ""
            
            if d > 0 {
                returnString.append("\(d)g, ")
            }
            if h >= 0 {
                returnString.append("\(h)h, ")
            }
            if m >= 0{
                returnString.append("\(m)m")
            }
            
            return returnString
        }
        return ""
    }
    
    func hourForTomorrow() -> String {
        let cal = Calendar(identifier: .gregorian)
        if let earlyDate = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: self){
            let tomorrow = cal.startOfDay(for: earlyDate)
            
            return self.remainTimeFrom(date: tomorrow)
        }
        return ""
    }
    
    var remainTimeToStart: String {
        let result = self.remainingTime
        let d = result.g
        let h = result.h - 24*d
        let m = result.m - 60*24*d - h*60
        
        var returnString = ""
        
        if d >= 0 {
            returnString.append("\(d)g, ")
        }
        if h >= 0 {
            returnString.append("\(h)h, ")
        }
        if m >= 0{
            returnString.append("\(m)m")
        }
        
        return returnString
        
    }
        
    /// Returns the a custom time interval description from another date
}
