//
//  FolderViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/12/24.
//

import Foundation

class FolderViewModel {
    var passFolder: PassDateDelegate?
    
    
    func passFolderData(list: Folder) {
        passFolder?.passList(list.category)
        
    }
    
    
    
    
    
}
