//
//  PassData.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import Foundation
import RealmSwift

protocol PassDateDelegate {
    func passDateValue(_ date: Date)
    func passTagValue(_ text: String)
    func passPriorityValue(_ text: String)
    func passList(_ text: String)
}
protocol PassDataDelegate {
    func passDataList(_ dataList: Results<RealmTable>)
}

protocol PassFolderDelegate {
    func passFolderList(_ dataList: Results<Folder>)
}
