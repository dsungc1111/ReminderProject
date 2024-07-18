//
//  TagViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation

final class TagViewModel {
    var passTag: PassDateDelegate?
    
    
    var inputTagText: Observable<String?> = Observable("")
    
    init() {
        inputTagText.bind { _ in
            self.passTagData()
        }
    }
    private func passTagData() {
        if let tag = inputTagText.value {
            passTag?.passTagValue(tag)
        }
    }
}
