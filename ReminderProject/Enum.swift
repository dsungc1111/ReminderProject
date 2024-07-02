//
//  Enum.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import Foundation

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
