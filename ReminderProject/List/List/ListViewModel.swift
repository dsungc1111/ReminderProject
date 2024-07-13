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
    }
    private func sortFunction(index: Int) {
        outputSortList.value = repository.sortList(index: index)
    }
    private func completeToDo() -> String{
        var image = ""
        guard let list = inputCompleteButton.value?.keys.first else { return "" }
        guard let index = inputCompleteButton.value?.values.first else { return "" }
        var updatedList = repository.completeButtonTapped(list: list, index: index)
        image = updatedList[index].isComplete == true ? "circle.fill" : "circle"
        
        return image
    }
}
