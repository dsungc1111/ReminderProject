//
//  Date+Extension.swift
//  ReminderProject
//
//  Created by 최대성 on 7/4/24.
//

import Foundation


extension Date {
    
    static let dateFormatter = DateFormatter()
    
    static func getDateString(date: Date) -> String{
        Date.dateFormatter.locale = Locale(identifier: "ko_KR")
        Date.dateFormatter.dateFormat = "yyyy.MM.dd E요일"
        let currentDateString = Date.dateFormatter.string(from: date)
        return currentDateString
    }
    func getDate(string: String) -> Date {
        print("12")
        Date.dateFormatter.locale = Locale(identifier: "ko_KR")
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        return Date.dateFormatter.date(from: string) ?? Date()
    }
}
