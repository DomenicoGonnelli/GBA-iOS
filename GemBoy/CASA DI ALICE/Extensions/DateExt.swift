//
//  DateExt.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 16/09/25.
//

extension Date {
    
    // Funzione per ottenere il giorno della settimana da una data
    func getDayOfWeek() -> DayOfWeek {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        
        // In Calendar, weekday va da 1 (domenica) a 7 (sabato)
        let weekdayNames = [
            "Domenica",
            "Lunedì",
            "Martedì",
            "Mercoledì",
            "Giovedì",
            "Venerdì",
            "Sabato"
        ]
        
        return DayOfWeek(rawValue: weekdayNames[weekday - 1]) ?? DayOfWeek.domenica
    }
    
    func toLongLabelDay() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "it_IT")
            dateFormatter.dateFormat = "EEEE, dd MMMM yyyy"
            return dateFormatter.string(from: self)
        }
    
    func generateDateList(days: Int) -> [Date] {
        let calendar = Calendar.current
        let today = self
        
        var dateList: [Date] = []
        
        for dayOffset in 0...days {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                dateList.append(date)
            }
        }
        
        return dateList
    }
}
