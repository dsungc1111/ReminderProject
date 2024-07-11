//
//  SearchViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation
import RealmSwift

final class SearchViewModel {
    
    private let realm = try! Realm()
    // 텍스트 받아와
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
        let filter = realm.objects(RealmTable.self).where {
            $0.memoTitle.contains(text, options: .caseInsensitive)
        }
        let result = Array(filter)
        return result
    } 
    
    func deleteToDo(list: [RealmTable], index: Int) {
        try! self.realm.write {
            self.realm.delete(list[index])
        }
        let filter = Array(self.realm.objects(RealmTable.self))
        outputList.value = filter
    }
    
    func changeFlag(list: [RealmTable], index: Int) {
        try! self.realm.write {
            list[index].isFlag.toggle()
            let filter = self.realm.create(RealmTable.self, value: ["key" : list[index].key, "isFlag" : list[index].isFlag], update: .modified)
        }
        outputList.value = list
    }
    
}
