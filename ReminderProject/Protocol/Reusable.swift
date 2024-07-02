//
//  Reusable.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit

extension UITableViewCell {
    static var id: String {
       return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var id: String {
       return String(describing: self)
    }
}
