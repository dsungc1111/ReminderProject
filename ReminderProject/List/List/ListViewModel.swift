//
//  ListViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/13/24.
//

import Foundation

final class ListViewModel {
    
    private let reporitory = RealmTableRepository()
    var inputDeleteAll: Observable<Void?> = Observable(nil)
    var outputDeleteAll: Observable<[RealmTable]?> = Observable(nil)
    
    var inputSortIndex: Observable<Int> = Observable(0)
    var outputSortList: Observable<[RealmTable]?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputDeleteAll.bindLater { _ in
            self.reporitory.deleteAll()
            self.outputDeleteAll.value = self.reporitory.fetchRealmTable()
        }
        inputSortIndex.bind { index in
            self.sortFunction(index: index)
        }
    }
    private func sortFunction(index: Int) {
        outputSortList.value = reporitory.sortList(index: index)
    }
}
