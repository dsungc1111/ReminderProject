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
    
    var inputSortIndex: Observable<Int> = Observable(0)
    var outputSortList: Observable<[RealmTable]?> = Observable(nil)
    
//    var inputCompleteButton: Observable<[[RealmTable] : Int]?> = Observable(nil)
//    var outputCompleteButton: Observable<String> = Observable("")
//    
//    var inputReloadList: Observable<Int> = Observable(0)
//    var outputReloadList: Observable<[RealmTable]?> = Observable(nil)
//    
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
//        inputReloadList.bindLater { value in
//            self.fetchList(index: value)
//        }
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
    
    let realm = try! Realm()
    private func completionButtonTapped() -> [RealmTable] {
        guard let list = inputCompleteButton.value.keys.first,
              let index = inputCompleteButton.value.values.first else { return [] }
        var aa = realm.objects(RealmTable.self)
        try! realm.write {
            list[index].isComplete.toggle()
            var value = realm.objects(RealmTable.self)
            for i in 0..<value.count {
                if value[i].key == list[index].key {
                    self.realm.create(RealmTable.self, value: ["key" : list[index].key, "isComplete" : list[index].isComplete], update: .modified)
                }
            }
            if list[index].isComplete {
                aa = self.realm.objects(RealmTable.self).filter("isComplete == false")
            } else {
                aa = self.realm.objects(RealmTable.self).filter("isComplete == true")
            }
        }
        return Array(aa)
    }
    
    
    
    private func fetchFilteredList() {
        let list = repository.fetchRealmTable().filter { !$0.isComplete }
              outputFilteredReloadList.value = list
    }
//    private func completeToDo() -> String {
//        var image = ""
//        guard let list = inputCompleteButton.value?.keys.first,
//              let index = inputCompleteButton.value?.values.first
//        else { return "" }
//     
//        let updateList = repository.completeButtonTapped(list: list, index: index)
//        for i in 0..<updateList.count {
//            if list[index].key == updateList[i].key {
//                image = updateList[i].isComplete ? "circle.fill" : "circle"
//            } else {
//                image = "circle"
//            }
//        }
//        return image
//    }
//    private func fetchList(index: Int) {
//        let list = repository.fetchRealmTable().filter { !$0.isComplete }
//           outputReloadList.value = list
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    private func sortFunction(index: Int) {
        outputSortList.value = repository.sortList(index: index)
    }
    private func getPriority(list: RealmTable) {
        outputPriority.value = repository.selectedPrioprity(list: list)
    }
    private func deleteToDo(list: [RealmTable], index: Int) {
        outputDeleteInfo.value = repository.deleteToDo(list: list, index: index)
    }
    private func changeStar(list: [RealmTable], index: Int) {
        outputStarList.value = repository.changeStar(list: list, index: index)
    }
    
}
