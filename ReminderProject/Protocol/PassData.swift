//
//  PassData.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import Foundation

protocol PassDateDelegate {
    func passDateValue(_ text: String)
    func passTagValue(_ text: String)
    func passPriorityValue(_ text: String)
}
