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
    var inputFileColor: Observable<String?> = Observable(nil)
    var outputFileColor: Observable<String> = Observable("")
    
    
    init() {
        transform()
    }
    private func transform() {
        inputFolderTitle.bind { [weak self] value in
            self?.checkTitle(text: value)
        }
        inputSaveFolder.bindLater { [weak self] title in
            print("1")
            self?.getNewFoler(title: title, color: self?.inputFileColor.value ?? "#007AFF")
            print("@")
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
    private func getNewFoler(title: String, color: String) {
        repository.createFolder(title: title, color: color)
        let list = repository.fetchFolder()
        passFolder?.passFolderList(list)
        outputSaveFolder.value = ()
    }
}
