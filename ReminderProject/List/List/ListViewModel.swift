//
//  ListViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/13/24.
//

import Foundation
import RealmSwift

final class ListViewModel {
    
    private let repository = RealmTableRepository()
    var getPageNumber = 0
    
    
    var inputSortIndex: Observable<Int> = Observable(0)
    var outputSortList: Observable<[RealmTable]?> = Observable(nil)
    
    var inputPriority: Observable<RealmTable?> = Observable(nil)
    var outputPriority: Observable<String?> = Observable(nil)
    
    var inputDeleteInfo: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputDeleteInfo: Observable<[RealmTable]?> = Observable(nil)
    
    var inputStarList: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputStarList: Observable<[RealmTable]?> = Observable(nil)
    
    var inputFilteredReloadList: Observable<Void?> = Observable(nil)
    var outputFilteredReloadList: Observable<[RealmTable]?> = Observable(nil)
    
    var inputCompleteButton: Observable<[[RealmTable] : Int]> = Observable([[] : 0])
    var outputCompleteButton: Observable<[RealmTable]?> = Observable(nil)
    
    init() {
        transform()
    }
    private func transform() {
        inputSortIndex.bind { index in
            self.sortFunction(index: index)
        }
        inputCompleteButton.bindLater { value in
            self.outputCompleteButton.value = self.completionButtonTapped()
        }
        inputPriority.bindLater { value in
            guard let value = value else { return }
            self.getPriority(list: value)
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
        inputFilteredReloadList.bindLater { _ in
                  self.fetchFilteredList()
              }
    }
    
    
    private func fetchFilteredList() {
        let list = repository.fetchRealmTable().filter { !$0.isComplete }
              outputFilteredReloadList.value = list
    }
    private func getPriority(list: RealmTable) {
        outputPriority.value = repository.selectedPrioprity(list: list)
    }
    
    // 카테고리에 따라 예외처리 달라질 놈들
    // 순서
    // 1. 완료 2. 삭제 3. 중요 4. sort
    private func sortFunction(index: Int) {
        outputSortList.value = repository.sortList(index: index)
    }
    private func completionButtonTapped() -> [RealmTable] {
        guard let list = inputCompleteButton.value.keys.first,
              let index = inputCompleteButton.value.values.first else { return [] }
        let filteredList = repository.changeCompleteButton(list: list, index: index, page: getPageNumber)
        return filteredList
    }
    private func deleteToDo(list: [RealmTable], index: Int) {
        outputDeleteInfo.value = repository.deleteToDo(list: list, index: index)
    }
    private func changeStar(list: [RealmTable], index: Int) {
        outputStarList.value = repository.changeStar(list: list, index: index, page: getPageNumber)
    }
    
}
