//
//  PriorityViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/9/24.
//

import Foundation


class PriorityViewModel {
    var passPriority: PassDateDelegate?
    
    var priorityText: Observable<String?> = Observable(nil)
    
    var completionButtonTapped: Observable<Void?> = Observable(nil)
    init() {
        priorityText.bind { _ in
            self.passPriorityData()
        }
    }
    func inputPriority(index: Int) {
        switch index {
        case 0:
            priorityText.value = "높음"
        case 1:
            priorityText.value = "중간"
        case 2:
            priorityText.value = "낮음"
        default:
            priorityText.value = ""
        }
    }
    private func passPriorityData() {
        if let priority = priorityText.value {
                  passPriority?.passPriorityValue(priority)
              }
    }
}
