//
//  Database.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import RealmSwift

class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var category: String
    @Persisted var content: List<RealmTable>
    
    convenience init(category: String, content: List<RealmTable>) {
        self.init()
        
        
        self.category = category
        self.content = content
    }
}


class RealmTable: Object {
   
    @Persisted(primaryKey: true) var key: ObjectId
    @Persisted(indexed: true) var memoTitle: String
    @Persisted var memo: String?
    @Persisted var date: Date?
    @Persisted var tag: String?
    @Persisted var priority: String?
    @Persisted var isFlag: Bool
    @Persisted var isComplete: Bool
    
    @Persisted(originProperty: "content") var main: LinkingObjects<Folder>

    convenience init(memoTitle: String, date: Date? = nil, memo: String? = nil, tag : String? , priority: String? = nil, isFlag: Bool, complete: Bool) {
        self.init()
        
        self.memoTitle = memoTitle
        self.date = date
        self.memo = memo
        self.tag = tag
        self.priority = priority
        self.isFlag = false
        self.isComplete = false
    }
    
}


extension UIViewController {
    func saveImageToDocument(image: UIImage, filename: String) {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        //이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        //이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        //이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    func loadImageToDocument(filename: String) -> UIImage? {
         
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
         
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        //이 경로에 실제로 파일이 존재하는 지 확인
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }

        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                print("file remove error", error)
            }
        } else {
            print("file no exist")
        }
        
    }
    
    
    
    
}
