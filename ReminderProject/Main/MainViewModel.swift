//
//  MainViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation

class MainViewModel {
    let repository = RealmTableRepository()
    
    var setListTitleTrigger: Observable<[Folder]> = Observable([])
    
    var inputPassList: Observable<Int> = Observable(0)
    var outputPassList: Observable<[RealmTable]> = Observable([])
    
    
    var inputDeleteInfo: Observable<[[Folder] : Int]?> = Observable(nil)
    var outputDeleteInfo: Observable<[Folder]> = Observable([])
    
    var inputFolderTrigger: Observable<Void?> = Observable(nil)
    var outputFolderTrigger:Observable<[Folder]> = Observable([])
    init() {
        transform()
    }
    private func transform() {
        setListTitleTrigger.value = repository.fetchFolder()
        inputPassList.bindLater { index in
            self.fetchCategory(index: index)
        }
        inputDeleteInfo.bindLater { value in
            guard let list = value?.keys.first else { return }
            guard let index = value?.values.first else { return }
            self.deleteFolder(list: list, index: index)
        }
        inputFolderTrigger.bind { _ in
            self.outputFolderTrigger.value = self.repository.fetchFolder()
        }
    }
    private func fetchCategory(index: Int) {
        outputPassList.value = repository.fetchCategory(cases: index)
    }
    private func deleteFolder(list: [Folder], index: Int) {
        outputDeleteInfo.value = repository.deleteFolder(list: list, index: index)
    }
}
