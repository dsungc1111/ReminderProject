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
    @Persisted var date: String?
    

    convenience init(memoTitle: String, date: String, memo: String? = nil) {
        self.init()
        self.memoTitle = memoTitle
        self.date = date
        self.memo = memo
        
        
    }
    
}
