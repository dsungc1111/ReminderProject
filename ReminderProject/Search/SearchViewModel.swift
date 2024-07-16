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
    var inputCompleteButton: Observable<[[RealmTable] : Int]> = Observable([[] : 0])
    var outputCompleteButton: Observable<[RealmTable]?> = Observable(nil)
    
    var inputReloadList: Observable<Void?> = Observable(nil)
    var outputReloadList: Observable<[RealmTable]?> = Observable(nil)
    
    var inputDeleteInfo: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputDeleteInfo: Observable<[RealmTable]> = Observable([])
    
    var inputStarList: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputStarList: Observable<[RealmTable]> = Observable([])
    
    init() {
        inputSearchText.bind { _ in
            if let text = self.inputSearchText.value {
                self.outputSearchList.value = self.filterSearchText(text: text)
            }
        }
        inputCompleteButton.bindLater { value in
            self.outputCompleteButton.value = self.completionButtonTapped()
        }
        inputReloadList.bindLater { _ in
            self.fetchList()
        }
        inputDeleteInfo.bindLater { value in
            guard let list = value?.keys.first else { return }
            guard let index = value?.values.first else { return }
            self.deleteToDo(list: list, index: index)
        }
        inputStarList.bindLater { value in
            guard let list = value?.keys.first else { return }
            guard let index = value?.values.first else { return }
            self.changeStar(list: list, index: index)
        }
    }
    private func filterSearchText(text: String) -> [RealmTable] {
        let result = repository.filterBySearchText(text: text)
        return result
    }
    private func completionButtonTapped() -> [RealmTable] {
        guard let list = inputCompleteButton.value.keys.first,
              let index = inputCompleteButton.value.values.first else { return [] }
        let filteredList = repository.changeCompleteButton(list: list, index: index, page: 5)
        return filteredList
    }
    private func fetchList() {
        let list = repository.fetchCategory(cases: 2)
        outputReloadList.value = list
    }
    private func deleteToDo(list: [RealmTable], index: Int) {
        outputDeleteInfo.value = repository.deleteToDo(list: list, index: index, page: 5)
        
    }
    private func changeStar(list: [RealmTable], index: Int) {
        outputStarList.value = repository.changeStar(list: list, index: index, page: 5)
    }
}
