//
//  AddToDoViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/11/24.
//

import Foundation

final class AddToDoViewModel {
  
    private enum CategoryToDo: String, CaseIterable {
        case dueDate = "마감일"
        case tag = "태그"
        case priority = "우선순위"
        case addImage = "이미지 추가"
        case list = "목록"
    }
    private let repository = RealmTableRepository()
    var passData: PassDataDelegate?
    var inputMemoTitle: Observable<String> = Observable("")
    var outputMemoTitle: Observable<Void?> = Observable(nil)
    var inputMemoContent: Observable<String> = Observable("")
    
    var inputCategoryTrigger: Observable<Void?> = Observable(nil)
    var inputSaveButton: Observable<Void?> = Observable(nil)
    
    
    var inputDueDate: Observable<Date> = Observable(Date())
    var inputTagText: Observable<String> = Observable("")
    var inputPriority: Observable<String?> = Observable(nil)
    var inputFolder: Observable<String?> = Observable(nil)
    lazy var getDataList: Observable<[String]> = Observable([inputTagText.value, inputPriority.value ?? "", "", inputFolder.value ?? ""])
    
    var getData: Observable<Void?> = Observable(nil)
    
    var outputDataList: Observable< RealmTable?> = Observable(nil)
    
    var outputSelectCategory: Observable<
        [String]> = Observable([""])
    
    init() {
        transform()
    }
    private func transform() {
        inputCategoryTrigger.bind { [weak self]  _ in
            self?.getCategory()
        }
        inputMemoTitle.bindLater { [weak self] _ in
            self?.outputMemoTitle.value = ()
        }
        inputSaveButton.bindLater { [weak self] _ in
            self?.saveData(memotitle: self?.inputMemoTitle.value ?? "", memo: self?.inputMemoContent.value ?? "")
        }
    }
    
}
extension AddToDoViewModel {
    private func getCategory(){
        outputSelectCategory.value = CategoryToDo.allCases.map { $0.rawValue }
    }
    private func saveData(memotitle: String, memo: String) {
        let newData = RealmTable(memoTitle: inputMemoTitle.value, date: inputDueDate.value, memo: inputMemoContent.value, tag: inputTagText.value, priority: inputPriority.value ?? "", isStar: false, complete: false )
        repository.saveData(text: inputFolder.value ?? "", data: newData)
        outputDataList.value = newData
        passData?.passDataList([newData])
    }
}
extension AddToDoViewModel: PassDateDelegate {
    func passDateValue(_ date: Date) {
        inputDueDate.value = date
        getData.value = ()
    }
    func passTagValue(_ text: String) {
        inputTagText.value = !text.isEmpty ? "# \(text)" : ""
        getDataList.value[0] = inputTagText.value
        getData.value = ()
    }
    func passPriorityValue(_ text: String) {
        inputPriority.value = text
        getDataList.value[1] = inputPriority.value ?? ""
        getData.value = ()
    }
    func passList(_ text: String) {
        inputFolder.value = text
        getDataList.value[3] = inputFolder.value ?? ""
        getData.value = ()
    }

   
}
