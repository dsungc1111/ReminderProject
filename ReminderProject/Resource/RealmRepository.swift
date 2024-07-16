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
    func fetchRealmTable() -> [RealmTable] {
        let value = realm.objects(RealmTable.self)
        return Array(value)
    }
    func fetchFolder() -> [Folder] {
        let value = realm.objects(Folder.self)
        return Array(value)
    }
    func fetchRealmTableByComplete() -> [RealmTable] {
        var value = realm.objects(RealmTable.self)
        value = value.filter("isComplete = false")
        return Array(value)
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
            value = value.filter("isStar == true && isComplete == false")
        case 4:
            value = value.filter("isComplete == true")
        default:
            return Array(value)
        }
        return Array(value)
    }
    func getToDoTable(date: Date) -> [RealmTable] {
        var value = realm.objects(RealmTable.self)
        value = value.filter("date BETWEEN {%@, %@} && isComplete == false", Calendar.current.startOfDay(for: date), Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: date)))
        return Array(value)
    }
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
    func deleteFolder(list: [Folder], index: Int) -> [Folder] {
        try! self.realm.write {
            self.realm.delete(list[index].content)
            self.realm.delete(list[index])
        }
        let filter = Array(self.realm.objects(Folder.self))
        return filter
    }
    func changeCompleteButton(list : [RealmTable], index:  Int, page: Int) -> [RealmTable] {
        let value = realm.objects(RealmTable.self)
        try! realm.write {
            list[index].isComplete.toggle()
            for i in 0..<value.count {
                if value[i].key == list[index].key {
                    self.realm.create(RealmTable.self, value: ["key" : list[index].key, "isComplete" : list[index].isComplete], update: .modified)
                }
            }
        }
        return fetchCategory(cases: page)
    }
    func deleteToDo(list: [RealmTable], index: Int, page: Int) -> [RealmTable] {
        var filter = list
        try! self.realm.write {
            self.realm.delete(list[index])
        }
        filter.remove(at: index)
        return filter
    }
    func changeStar(list: [RealmTable], index: Int, page: Int) -> [RealmTable]{
        try! self.realm.write {
            list[index].isStar.toggle()
           self.realm.create(RealmTable.self, value: ["key" : list[index].key, "isStar" : list[index].isStar], update: .modified)
        } 
        return fetchCategory(cases: page)
    }
    func saveData(text: String, data: RealmTable) {
        if let folder = realm.objects(Folder.self).filter("category == %@", text).first {
            try! realm.write {
                folder.content.append(data)
            }
        }
    }
    func createFolder(title: String) {
        let newFolder = Folder(category: title, content: List<RealmTable>())
        try! realm.write {
            realm.add(newFolder)
        }
    }
    func sortList(index: Int) -> [RealmTable] {
        var list = fetchRealmTableByComplete()
        switch index {
        case 0:
           list.sort { $0.memoTitle < $1.memoTitle }
        case 1:
            list.sort { $0.memo ?? "" > $1.memo ?? "" }
        case 2:
            list.sort {$0.date ?? Date() < $1.date ?? Date()}
        default:
            list.sort { $0.memoTitle < $1.memoTitle }
        }
        return list
    }
    func filterByMemoContents(memo: String, id: ObjectId) {
        try! realm.write {
            self.realm.create(RealmTable.self, value: ["key" :id, "memo" : memo], update: .modified)
        }
    }
    func filterByMemoTitle(title: String, id: ObjectId) {
        let result = realm.objects(RealmTable.self).filter("key == %@", id)
        try! realm.write {
            result.setValue(title, forKey: "\(MemoContents.memoTitle.rawValue)")
        }
    }
    
    func filterByBothThings(title: String, memo: String, id: ObjectId) {
        let result = realm.objects(RealmTable.self).filter("key == %@", id)
        try! realm.write {
            result.setValue(title, forKey: "\(MemoContents.memoTitle.rawValue)")
            result.setValue(memo, forKey: "\(MemoContents.memo.rawValue)")
        }
    }
    
}
