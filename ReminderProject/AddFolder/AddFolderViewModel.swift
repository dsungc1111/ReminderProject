//
//  AddFolderViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation

final class AddFolderViewModel {
    
    private let repository = RealmTableRepository()
    var passFolder: PassFolderDelegate?
    
    var inputFolderTitle: Observable<String> = Observable("")
    var outputFolderTitle: Observable<Bool?> = Observable(nil)
    
    var inputSaveFolder: Observable<String> = Observable("")
    var outputSaveFolder:  Observable<Void?> = Observable(nil)
    
    init() {
        transform()
    }
    private func transform() {
        inputFolderTitle.bind { value in
            self.checkTitle(text: value)
        }
        inputSaveFolder.bindLater { title in
            self.getNewFoler(title: title)
        }
    }
    private func checkTitle(text: String?)  {
        guard let text = text  else { return }
        if text.contains(" ") || text.isEmpty {
            outputFolderTitle.value = false
        } else {
            outputFolderTitle.value = true
        }
    }
    private func getNewFoler(title: String) {
        repository.createFolder(title: title)
        let list = repository.fetchFolder()
        passFolder?.passFolderList(list)
        outputSaveFolder.value = ()
    }
}
