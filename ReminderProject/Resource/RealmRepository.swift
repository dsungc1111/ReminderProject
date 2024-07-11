//
//  RealmRepository.swift
//  ReminderProject
//
//  Created by 최대성 on 7/8/24.
//

import Foundation

import RealmSwift


final class RealmTableRepository {
    
    private let realm = try! Realm()
    
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
    func fetchCategory(cases: Int) -> [RealmTable] {
        let date = Date()
        var value = realm.objects(RealmTable.self)
        switch cases {
        case 0:
            value = value.filter("date BETWEEN {%@, %@} && isComplete == false", Calendar.current.startOfDay(for: date), Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: date)))
        case 1:
            value = value.filter("date > %@ && isComplete == false", Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: date)))
        case 2:
            value = value.sorted(byKeyPath: MemoContents.memoTitle.rawValue , ascending: true)
            value = value.filter("isComplete == false")
        case 3:
            value = value.filter("isFlag == true")
        case 4:
            value = value.filter("isComplete == true")
        default:
            return Array(value)
        }
        
        return Array(value)
    }
    var list: [RealmTable] = []
    func selectedPrioprity(list: RealmTable) -> String{
        switch list.priority {
        case "높음":
            return "!!! " + list.memoTitle
        case "중간":
            return "!! " + list.memoTitle
        case "낮음":
            return "! " + list.memoTitle
        default:
            return list.memoTitle
        }
    }
    func filterBySearchText(text: String) -> [RealmTable] {
        let filter = realm.objects(RealmTable.self).where {
            $0.memoTitle.contains(text, options: .caseInsensitive)
        }
        let result = Array(filter)
        return result
    }
    func completeButtonTapped(list: [RealmTable], index: Int)  -> [RealmTable] {
        try! self.realm.write {
            list[index].isComplete.toggle()
            self.realm.create(RealmTable.self, value: ["key" : list[index].key, "isComplete" : list[index].isComplete], update: .modified)
        }
        let result = Array(self.realm.objects(RealmTable.self))
        return result
    }
    func deleteToDo(list: [RealmTable], index: Int) -> [RealmTable] {
        try! self.realm.write {
            self.realm.delete(list[index])
        }
        let filter = Array(self.realm.objects(RealmTable.self))
        return filter
    }
    func changeFlag(list: [RealmTable], index: Int) -> [RealmTable]{
        try! self.realm.write {
            list[index].isFlag.toggle()
            let filter = self.realm.create(RealmTable.self, value: ["key" : list[index].key, "isFlag" : list[index].isFlag], update: .modified)
            self.list = [filter]
        }
        return list
    }
}
