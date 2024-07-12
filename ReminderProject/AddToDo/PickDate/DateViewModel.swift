//
//  PickDateViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/9/24.
//

import Foundation

final class DateViewModel {
    var passDate: PassDateDelegate?
    
    var pickDate: Observable<Date?> = Observable(Date())

    
    var completionButtonTapped: Observable<Void?> = Observable(nil)
    
    
    init() {
        completionButtonTapped.bind { _ in
            self.passDateInfo()
        }
    }
    
    private func passDateInfo() {
        if let date = pickDate.value {
            passDate?.passDateValue(date)
        }
    }
    
    
    
}
