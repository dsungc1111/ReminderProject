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
        Date.dateFormatter.locale = Locale(identifier: "ko")
        Date.dateFormatter.dateFormat = "yyyy.MM.dd E요일"
        let currentDateString = Date.dateFormatter.string(from: date)
        return currentDateString
    }
    
}
