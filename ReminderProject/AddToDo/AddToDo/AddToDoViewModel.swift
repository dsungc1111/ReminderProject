//
//  AddToDoViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/11/24.
//

import Foundation

final class AddToDoViewModel: PassDateDelegate {
    
    private enum CategoryToDo: String, CaseIterable {
        case dueDate = "마감일"
        case tag = "태그"
        case priority = "우선순위"
        case addImage = "이미지 추가"
        case list = "목록"
    }
    var getDueDate: Date?
    var getTagText = ""
    var getPriority = ""
    var getFolder = ""
    var passData: PassDataDelegate?
    lazy var getDataList = [getTagText, getPriority, "", getFolder]
    
    private let repository = RealmTableRepository()
  // 데어터 받았을 때
    var getData: Observable<
        Void?> = Observable(nil)
    
    //뷰컨에서 받은 데이터들로 새로운 데이터 배열 생성 후 output
    var outputDataList: Observable< RealmTable?> = Observable(nil)
    // 메모 타이틀 받아오는 인스턴스
    var inputMemoTitle: Observable<
        String?> = Observable(nil)
    // 메모내용을 받아오는 인스턴스
    var inputMemoContent: Observable<
        String?> = Observable(nil)
    // 저장 버트 눌렀음을 알게해주는 인스턴스
    var saveButtontapped: Observable<
        Void?> = Observable(nil)
    // ToDo Category 눌렀음 인지
    var inputSelectCategory: Observable<
        Void?> = Observable(nil)
    // ToDo Category 전달해주는 인스턴스
    var outputSelectCategory: Observable<
        [String]?> = Observable(nil)
    
    init() {
        inputSelectCategory.bind { _ in
            self.getCategory()
        }
    }

    func passDateValue(_ date: Date) {
        getDueDate = date
        getData.value = ()
    }
    func passTagValue(_ text: String) {
        getTagText = !text.isEmpty ? "# \(text)" : ""
        getData.value = ()
    }
    func passPriorityValue(_ text: String) {
        getPriority = text
        getData.value = ()
    }
    func passList(_ text: String) {
        getFolder = text
        getData.value = ()
    }
    func saveData(memotitle: String, memo: String) {
        let newData = RealmTable(memoTitle: memotitle, date: getDueDate, memo: memo, tag: getTagText, priority: getPriority, isFlag: false, complete: false )
        repository.saveData(text: getFolder, data: newData)
        outputDataList.value = newData
        passData?.passDataList([newData])
    }
    
    private func getCategory(){
        outputSelectCategory.value = CategoryToDo.allCases.map { $0.rawValue }
    }
}
