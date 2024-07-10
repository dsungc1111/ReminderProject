//
//  AddFolderViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/10/24.
//

import Foundation
import RealmSwift

final class AddFolderViewModel {
    
    private let realm = try! Realm()
    // 폴더 제목 적을 때 적힌놈을 받아오고
    var inputFolderTitle: Observable<String?> = Observable(nil)
    // 텍스트가 바뀔 때마다 바뀌고 있음을 알려주는 기능
    var inputTextChange: Observable<Void?> = Observable(nil)
    // 텍스트 조건에 따라 저장버튼을 막을지 말지
    var outputButtonBlock: Observable<Bool?> = Observable(nil)
    // 저장 버튼 눌렀을 때의 폴더 명 받아와서
    var inputFolderName: Observable<String?> = Observable(nil)
    // 저장 누르면 바ㄱ뀌는 놈
    var inputFolderChanged: Observable<Void?> = Observable(nil)
    
    init() {
        inputTextChange.bind { _ in
            if let text = self.inputFolderTitle.value {
                self.checkTitle(text: text)
            }
        }
        inputFolderChanged.bind { _ in
            if let text = self.inputFolderName.value,
               !text.isEmpty {
                self.getNewFoler(title: text)
            }
        }
    }
    private func checkTitle(text: String?)  {
        guard let text = text  else { return }
        if text.contains(" ") || text.isEmpty {
            outputButtonBlock.value = false
        } else {
            outputButtonBlock.value = true
        }
        
    }
    
    private func getNewFoler(title: String) {
        let newFolder = Folder(category: title, content: List<RealmTable>())
        try! realm.write {
            realm.add(newFolder)
        }
    }
    
}
