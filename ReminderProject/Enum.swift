//
//  Enum.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit

enum ContentNameEnum: String, CaseIterable {
    case today = "오늘"
    case plan = "예정"
    case all = "전체"
    case flag = "깃발 표시"
    case complete = "완료됨"
}
enum ContentLogoImageEnum: String, CaseIterable {
    case today = "arrowshape.right.circle"
    case plan = "calendar.circle"
    case all = "tray.circle"
    case flag = "flag.circle"
    case complete = "checkmark.circle.fill"
}


enum SortButtonImages: String {
    case ellipsis = "ellipsis.circle"
    case lineweight
    case note
    case calender = "calendar.badge.clock"
}
enum SortButtonTitle: String {
    case sortButton = "정렬"
    case sortByTitle = "제목순"
    case sortByContent = "메모/내용순"
    case sortByTime = "시간순"
}
enum MemoContents: String {
    case memoTitle
    case memo
    case date
}

enum ContentLogoColorEnum: String, CaseIterable {
    case systemBlue
    case systemRed
    case black
    case systemYellow
    case systemGray
}
extension ContentLogoColorEnum {
    var value: UIColor {
        switch self {
        case .systemBlue:
            return UIColor.systemBlue
        case .systemRed:
            return UIColor.systemRed
        case .black:
            return UIColor.black
        case .systemYellow:
            return UIColor.systemYellow
        case .systemGray:
            return UIColor.systemGray
        }
    }
}
