//
//  PriorityViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/9/24.
//

import Foundation


class PriorityViewModel {
   
    var passPriority: PassDateDelegate?
    
    var inputPriority: Observable<Int?> = Observable(nil)
    var outputPriority: Observable<String?> = Observable(nil)
    
    var completionButtonTapped: Observable<Void?> = Observable(nil)
    
    init() {
        inputPriority.bind { [weak self] value in
            if let value = value {
                self?.inputPriority(index: value)
            }
        }
        completionButtonTapped.bind { [weak self] _ in
            self?.passPriorityData()
        }
    }
    private func inputPriority(index: Int) {
        switch index {
        case 0:
            outputPriority.value = "높음"
        case 1:
            outputPriority.value = "중간"
        case 2:
            outputPriority.value = "낮음"
        default:
            outputPriority.value = ""
        }
    }
    private func passPriorityData() {
        if let priority = outputPriority.value {
                  passPriority?.passPriorityValue(priority)
              }
    }
}
