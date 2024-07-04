//
//  Database.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import Foundation
import RealmSwift

class RealmTable: Object {
   
    @Persisted(primaryKey: true) var key: ObjectId
    @Persisted(indexed: true) var memoTitle: String
    @Persisted var memo: String?
    @Persisted var date: Date?
    @Persisted var tag: String?
    @Persisted var priority: String?
    @Persisted var isFlag: Bool
    @Persisted var isComplete: Bool
    

    convenience init(memoTitle: String, date: Date? = nil, memo: String? = nil, tag : String? , priority: String? = nil, isFlag: Bool, complete: Bool) {
        self.init()
        self.memoTitle = memoTitle
        self.date = date
        self.memo = memo
        self.tag = tag
        self.priority = priority
        self.isFlag = false
        self.isComplete = false
    }
    
}
