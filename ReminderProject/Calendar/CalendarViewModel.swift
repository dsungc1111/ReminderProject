//
//  CalendarViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation
import RealmSwift

final class CalendarViewModel {
    
    private let realm = try! Realm()
    
    var inputMonthOrWeek: Observable<Bool?> = Observable(true)
    
    var outputSelecteDate: Observable<Results<RealmTable>?> = Observable(nil)

    func selectDate(date: Date) {
        outputSelecteDate.value = realm.objects(RealmTable.self).filter("date BETWEEN {%@, %@} && isComplete == false", Calendar.current.startOfDay(for: date), Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: date)))
        
    }
    
    func setPickedDate() {
        
    }
 
    
}
