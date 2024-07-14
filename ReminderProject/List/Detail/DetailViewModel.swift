//
//  DetailViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/13/24.
//

import Foundation
import RealmSwift

class DetailViewModel {
    private let repository = RealmTableRepository()
    var getId = ObjectId()
    var inputMemoTitle: Observable<String> = Observable("")
    var inputMemoContent: Observable<String> = Observable("")
    var inputEditButton: Observable<Void?> = Observable(nil)
    var outputMemoTitle: Observable<String> = Observable("")
    var outputMemoContent: Observable<String> = Observable("")
    var outputEditButton: Observable<Void?> = Observable(nil)
    
    init() {
        transform()
    }
    private func transform() {
        inputEditButton.bindLater { _ in
            let title = self.inputMemoTitle.value
            let content = self.inputMemoContent.value
            self.filterText(title: title, content: content)
        }
    }
    private func filterText(title: String, content: String) {
        if title == "" && content == "" {
            outputMemoTitle.value = ""
            outputMemoContent.value = ""
        } else if title == "" && !content.isEmpty {
            repository.filterByMemoContents(memo: content, id: getId)
            outputMemoContent.value = content
        } else if !title.isEmpty && content == "" {
            repository.filterByMemoTitle(title: title, id: getId)
            outputMemoTitle.value = title
        } else {
            repository.filterByBothThings(title: title, memo: content, id: getId)
            outputMemoTitle.value = title
            outputMemoContent.value = content
        }
        outputEditButton.value = ()
    }
}