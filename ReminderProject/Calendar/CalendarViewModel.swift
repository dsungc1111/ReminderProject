//
//  CalendarViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation


final class CalendarViewModel {
    
    private let repository = RealmTableRepository()
    
    var monthOrWeek: Observable<Bool?> = Observable(true)

    var outputSelecteDateList: Observable<[RealmTable]?> = Observable(nil)
    func selectDate(date: Date) {
        outputSelecteDateList.value = repository.fetchCategory(cases: 0)
    }
}
