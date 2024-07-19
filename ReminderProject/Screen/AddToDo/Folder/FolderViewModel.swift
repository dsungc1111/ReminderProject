//
//  FolderViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/12/24.
//

import Foundation

class FolderViewModel {
    var passFolder: PassDateDelegate?
   
    private let repository = RealmTableRepository()
    
    var inputListTrigger: Observable<Void?> = Observable(nil)
    var outputListTitle: Observable<[Folder]> = Observable([])
    
    var inputSelectedFolder: Observable<Folder?> = Observable(nil)
    
    var outputSelectedFolder: Observable<Void?> = Observable(nil)
    
    init() {
        transform()
    }
    private func transform() {
        inputListTrigger.bind { [weak self] _ in
            self?.outputListTitle.value = self?.repository.fetchFolder() ?? []
        }
        
        inputSelectedFolder.bind { [weak self] value in
            if let value = value {
                self?.passFolderData(list: value)
            }
        }
    }
    private func passFolderData(list: Folder) {
        passFolder?.passList(list.category)
    }
    
    
    
    
    
}
