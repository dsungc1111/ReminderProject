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
    var inputDate: Observable<Date> = Observable(Date())
    var outputSelecteDateList: Observable<[RealmTable]?> = Observable(nil)
    
    init() {
        transform()
    }
    private func transform() {
        inputDate.bind { [weak self] date in
            self?.selectDate(date: date)
        }
    }
    private func selectDate(date: Date) {
        outputSelecteDateList.value = repository.getToDoTable(date: date)
    }
}
