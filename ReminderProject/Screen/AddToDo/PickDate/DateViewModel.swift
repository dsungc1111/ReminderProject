//
//  PickDateViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/9/24.
//

import Foundation

final class DateViewModel {
    
    var passDate: PassDateDelegate?
    
    var inputPickDate: Observable<Date?> = Observable(Date())
    var outputPickDate: Observable<String?> = Observable("")
    
    var inputCompletionButtonTapped: Observable<Void?> = Observable(nil)
    
    
    init() {
        transform()
    }
    private func transform() {
        inputPickDate.bind { [weak self] _ in
            if let date = self?.inputPickDate.value {
                self?.outputPickDate.value = Date.getDateString(date: date)
            }
        }
        inputCompletionButtonTapped.bind { [weak self] _ in
            self?.passDateInfo()
        }
    }
    private func passDateInfo() {
        if let date = inputPickDate.value {
            passDate?.passDateValue(date)
        }
    }
}
