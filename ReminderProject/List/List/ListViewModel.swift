//
//  ListViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/13/24.
//

import Foundation

final class ListViewModel {
    
    private let repository = RealmTableRepository()
    var inputDeleteAll: Observable<Void?> = Observable(nil)
    var outputDeleteAll: Observable<[RealmTable]?> = Observable(nil)
    
    var inputSortIndex: Observable<Int> = Observable(0)
    var outputSortList: Observable<[RealmTable]?> = Observable(nil)
    var inputCompleteButton: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputCompleteButton: Observable<String?> = Observable(nil)
    
    var inputReloadList: Observable<Int> = Observable(0)
    var outputReloadList: Observable<[RealmTable]?> = Observable(nil)
    
    var inputPriority: Observable<RealmTable?> = Observable(nil)
    var outputPriority: Observable<String?> = Observable(nil)
    
    var inputDeleteInfo: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputDeleteInfo: Observable<[RealmTable]?> = Observable(nil)
    
    var inputFlagList: Observable<[[RealmTable] : Int]?> = Observable(nil)
    var outputFlagList: Observable<[RealmTable]?> = Observable(nil)
    
    
    init() {
        transform()
    }
    
    private func transform() {
        inputDeleteAll.bindLater { _ in
            self.repository.deleteAll()
            self.outputDeleteAll.value = self.repository.fetchRealmTable()
        }
        inputSortIndex.bind { index in
            self.sortFunction(index: index)
        }
        inputCompleteButton.bindLater { _ in
            self.outputCompleteButton.value = self.completeToDo()
        }
        inputReloadList.bindLater { value in
            self.fetchList(index: value)
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
        inputFlagList.bindLater { value in
            guard let list = value?.keys.first else { return }
            guard let index = value?.values.first else { return }
            self.changeFlag(list: list, index: index)
        }
    }
    
    private func sortFunction(index: Int) {
        outputSortList.value = repository.sortList(index: index)
    }
    private func completeToDo() -> String{
        var image = ""
        guard let list = inputCompleteButton.value?.keys.first else { return "" }
        guard let index = inputCompleteButton.value?.values.first else { return "" }
        let updatedList = repository.completeButtonTapped(list: list, index: index)
        if updatedList.count != 0 {
            image = updatedList[index].isComplete == true ? "circle.fill" : "circle"
        } else { image = "circle" }
        return image
    }
    private func fetchList(index: Int) {
        var list = repository.fetchRealmTable()
        if list[index].isComplete == true {
             list = repository.fetchCategory(cases: 2)
        } else {
            list = repository.fetchCategory(cases: 4)
        }
        outputReloadList.value = list
    }
    private func getPriority(list: RealmTable) {
        outputPriority.value = repository.selectedPrioprity(list: list)
    }
    
    private func deleteToDo(list: [RealmTable], index: Int) {
        outputDeleteInfo.value = repository.deleteToDo(list: list, index: index)
    }
    private func changeFlag(list: [RealmTable], index: Int) {
        outputFlagList.value = repository.changeFlag(list: list, index: index)
    }
    
}
