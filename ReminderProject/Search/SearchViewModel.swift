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
    //
    var inputSearchTextChange: Observable<Void?> = Observable(nil)
    
    var outputText: Observable<[RealmTable]?> = Observable(nil)
    
    init() {
        inputSearchTextChange.bind { _ in
            if let text = self.inputSearchText.value {
                self.outputText.value = self.filterSearchText(text: text)
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
    
    
}
