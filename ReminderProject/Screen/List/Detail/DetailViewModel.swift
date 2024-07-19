//
//  DetailViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/13/24.
//

import Foundation
import RealmSwift

class DetailViewModel {
    deinit {
        print("d")
    }
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
        inputEditButton.bindLater { [weak self] _ in
            let title = self?.inputMemoTitle.value
            let content = self?.inputMemoContent.value
            self?.filterText(title: title ?? "", content: content ?? "")
        }
    }
    private func filterText(title: String, content: String) {
//        if title.isEmpty && content.isEmpty {
//            outputMemoTitle.value = ""
//            outputMemoContent.value = ""
//            print("듈 다 빈 칸")
//        } else if title.isEmpty && !content.isEmpty {
//            repository.filterByMemoContents(memo: content, id: getId)
//            outputMemoContent.value = content
//            print("제목빈칸")
//        } else if !title.isEmpty && content.isEmpty {
//            repository.filterByMemoTitle(title: title, id: getId)
//            outputMemoTitle.value = title
//            print("내용빈칸")
//        } else {
            repository.filterByBothThings(title: title, memo: content, id: getId)
            outputMemoTitle.value = title
            outputMemoContent.value = content
//            print("빈칸없음")
//        }
        outputEditButton.value = ()
    }
}
