//
//  PriorityViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/9/24.
//

import Foundation


class PriorityViewModel {
    
    var selectedSegment: Observable<String?> = Observable(nil)
    init() {
        selectedSegment.bind { _ in
            self.selectedSegment.value = "대기중"
        }
    }
    func outputPriority(index: Int) {
           switch index {
           case 0:
               selectedSegment.value = "높음"
           case 1:
               selectedSegment.value = "중간"
           case 2:
               selectedSegment.value = "낮음"
           default:
               selectedSegment.value = ""
           }
       }
}
