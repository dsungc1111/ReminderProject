//
//  Enum.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit

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
