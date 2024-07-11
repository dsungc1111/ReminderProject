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
    var inputSearchTextChange: Observable<Void?> = Observable(nil)
    var outputList: Observable<[RealmTable]?> = Observable(nil)
   
    var inputFlagChange: Observable<Void?> = Observable(nil)
    var inputFlagList: Observable<RealmTable?> = Observable(nil)
    
    init() {
        inputSearchTextChange.bind { _ in
            if let text = self.inputSearchText.value {
                self.outputList.value = self.filterSearchText(text: text)
            }
        }
    }
    private func filterSearchText(text: String) -> [RealmTable] {
        let result = repository.filterBySearchText(text: text)
        return result
    }
    func completeButtonTapped(list: [RealmTable], index: Int) -> String {
        var image = ""
        outputList.value = repository.completeButtonTapped(list: list, index: index)
        image = list[index].isComplete ? "circle.fill" : "circle"
        return image
    }
    func deleteToDo(list: [RealmTable], index: Int) {
        outputList.value = repository.deleteToDo(list: list, index: index)
    }
    func changeFlag(list: [RealmTable], index: Int) {
        outputList.value = repository.changeFlag(list: list, index: index)
    }
    
}
