//
//  PriorityViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/9/24.
//

import Foundation


class PriorityViewModel {
    
    var outputPriority: Observable<String?> = Observable(nil)
    init() {
        outputPriority.bind { _ in
            self.outputPriority.value = "대기중"
        }
    }
    func inputPriority(index: Int) {
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
}
