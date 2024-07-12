//
//  FolderViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/12/24.
//

import Foundation

class FolderViewModel {
    var passFolder: PassDateDelegate?
    
    var inputSelectedFolder: Observable<Folder?> = Observable(nil)
    
    var outputSelectedFolder: Observable<Void?> = Observable(nil)
    
    init() {
        transform()
    }
    private func transform() {
        inputSelectedFolder.bind { value in
            if let value = value {
                self.passFolderData(list: value)
            }
        }
    }
    private func passFolderData(list: Folder) {
        passFolder?.passList(list.category)
    }
    
    
    
    
    
}
