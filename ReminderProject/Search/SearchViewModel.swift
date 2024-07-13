//
//  SearchViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation

final class SearchViewModel {
    
    private let repository = RealmTableRepository()
    
    var inputSearchText: Observable<String?> = Observable(nil)
    var outputSearchList: Observable<[RealmTable]> = Observable([])
    var inputCompleteButton: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputCompleteButton: Observable<String> = Observable("")
    
    var inputReloadList: Observable<Void?> = Observable(nil)
    var outputReloadList: Observable<[RealmTable]?> = Observable(nil)
    
    
    var inputDeleteInfo: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputDeleteInfo: Observable<[RealmTable]> = Observable([])
    
    var inputFlagList: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputFlagList: Observable<[RealmTable]> = Observable([])
    
    init() {
        inputSearchText.bind { _ in
            if let text = self.inputSearchText.value {
                self.outputSearchList.value = self.filterSearchText(text: text)
            }
        }
        inputCompleteButton.bindLater { value in
            guard let list = self.inputCompleteButton.value?.keys.first else { return }
            guard let index = self.inputCompleteButton.value?.values.first else { return }
            self.completeButtonTapped(list: list, index: index)
        }
        inputReloadList.bindLater { _ in
            self.fetchList()
        }
        inputDeleteInfo.bindLater { value in
            guard let list = value?.keys.first else { return }
            guard let index = value?.values.first else { return }
            self.deleteToDo(list: list, index: index)
        }
        inputFlagList.bindLater { value in
            guard let list = value?.keys.first else { return }
            guard let index = value?.values.first else { return }
            self.changeFlag(list: list, index: index)
        }
    }
    private func filterSearchText(text: String) -> [RealmTable] {
        let result = repository.filterBySearchText(text: text)
        return result
    }
    private func completeButtonTapped(list: [RealmTable], index: Int) {
        outputSearchList.value = repository.completeButtonTapped(list: list, index: index)
        
        let updatedList = repository.completeButtonTapped(list: list, index: index)
        outputCompleteButton.value = updatedList[index].isComplete ? "circle.fill" : "circle"
    }
    private func fetchList() {
        let list = repository.fetchCategory(cases: 2)
        outputReloadList.value = list
    }
    
    private func deleteToDo(list: [RealmTable], index: Int) {
        outputDeleteInfo.value = repository.deleteToDo(list: list, index: index)
    }
    private func changeFlag(list: [RealmTable], index: Int) {
        outputFlagList.value = repository.changeFlag(list: list, index: index)
    }
}
