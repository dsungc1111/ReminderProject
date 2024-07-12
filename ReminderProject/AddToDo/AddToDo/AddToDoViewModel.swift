//
//  AddToDoViewModel.swift
//  ReminderProject
//
//  Created by 최대성 on 7/11/24.
//

import Foundation

class AddToDoViewModel: PassDateDelegate {
    var getDueDate: Date?
    var getTagText = ""
    var getPriority = ""
    var getFolder = ""
    
    private let repository = RealmTableRepository()
    var inputData: Observable<
        Void?> = Observable(nil)
    var outputData: Observable<
        Void?> = Observable(nil)
    
    init() {
      
        
    }
    
    
    
    
    func passDateValue(_ date: Date) {
        getDueDate = date
        outputData.value = ()
    }
    func passTagValue(_ text: String) {
        getTagText = !text.isEmpty ? "# \(text)" : ""
        outputData.value = ()
    }
    func passPriorityValue(_ text: String) {
        getPriority = text
        outputData.value = ()
    }
    func passList(_ text: String) {
        getFolder = text
        outputData.value = ()
    }
    func saveData(data: RealmTable) {
        repository.saveData(text: getFolder, data: data)
        
    }
   
    
    
}
