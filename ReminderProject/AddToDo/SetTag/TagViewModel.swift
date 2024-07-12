//
//  TagViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation

final class TagViewModel {
    var passTag: PassDateDelegate?
    
    
    var tagText: Observable<String?> = Observable("")
    
    init() {
        tagText.bind { _ in
            self.passTagData()
        }
    }
    
    
    private func passTagData() {
        if let tag = tagText.value {
            print(tag)
            passTag?.passTagValue(tag)
        }
        
    }
}
