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
    
    init() {
        
    }
    
    func selectDate(date: Date) {
        DataList.list = realm.objects(RealmTable.self).filter("date BETWEEN {%@, %@} && isComplete == false", Calendar.current.startOfDay(for: date), Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: date)))
        outputSelecteDate.value = DataList.list
        
    }
    
    func deselectDate(date: Date) {
        DataList.list = realm.objects(RealmTable.self).filter("date BETWEEN {%@, %@} && isComplete == true", Calendar.current.startOfDay(for: date), Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: date)))
        
        outputSelecteDate.value = DataList.list
    }
    
    
}