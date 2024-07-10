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
    
    func fetchFolder() -> [Folder] {
        let value = realm.objects(Folder.self)
        return Array(value)
    }
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
    func createFolder(category: String, content: List<RealmTable>) {
        do {
            try realm.write {
                let folder = Folder(category: category, content: content)
                realm.add(folder)
            }
        } catch {
            print("Realm Error")
        }
    }
    func createItem(_ data: RealmTable, folder: Folder) {
        
//        let folder = realm.objects(Folder.self).where {
//            $0.name == "개인"
//        }.first
        
        do {
            try realm.write {
                folder.content.append(data)
                print("realm create succeed")
            }
        } catch {
            print("Realm Error")
        }
        
    }
    
    func fetchAll() -> [RealmTable] {
        let value = realm.objects(RealmTable.self)
        
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
            value = value.filter("isFlag == true")
        case 4:
            value = value.filter("isComplete == true")
        default:
            return Array(value)
        }
        
        return Array(value)
        
    }
   
    func addFolder(_ folder: Folder) {
        do {
            try realm.write {
                realm.add(folder)
            }
        } catch {
            print("Error")
        }
    }
    func removeFolder(_ folder: Folder) {
        do {
            try realm.write {
//                realm.delete(folder.content)
                realm.delete(folder)
                print("folder remove")
            }
        } catch {
            print("folder didnt remove")
        }
    }
    
    
    
    func removeItem(_ data: RealmTable) {
        try! realm.write {
            realm.delete(data)
        }
    }
    
    func getSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print(version)
        } catch {
            print("error")
        }
    }
}
