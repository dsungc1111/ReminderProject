//
//  PickDateViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/9/24.
//

import Foundation

class DateViewModel {
    
    var pickDate: Observable<Date?> = Observable(nil)
    
    init() {
        pickDate.bind { _ in
            self.pickDate.value = Date()
        }
    }
    
}
