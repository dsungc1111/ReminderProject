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
    
    init() {
        transform()
    }
    private func transform() {
        setListTitleTrigger.value = repository.fetchFolder()
        inputPassList.bindLater { index in
            self.fetchCategory(index: index)
        }
    }
    private func fetchCategory(index: Int) {
        outputPassList.value = repository.fetchCategory(cases: index)
    }
    
}
