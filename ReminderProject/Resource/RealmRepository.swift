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
}
