//
//  AddFolderViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation

final class AddFolderViewModel {
    
    var inputFolderTitle: Observable<String?> = Observable(nil)
    var inputTextChange: Observable<Void?> = Observable(nil)
    
    var outputButtonBlock: Observable<Bool?> = Observable(nil)
    
    init() {
        inputTextChange.bind { _ in
            if let text = self.inputFolderTitle.value {
                self.checkTitle(text: text)
            }
        }
    }
    private func checkTitle(text: String?)  {
        guard let text = text  else { return }
        if text.contains(" ") || text.isEmpty {
            outputButtonBlock.value = false
        } else {
            outputButtonBlock.value = true
        }
        
    }
}
