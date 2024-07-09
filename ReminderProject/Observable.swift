//
//  Observable.swift
//  ReminderProject
//
//  Created by 최대성 on 7/9/24.
//

import Foundation

class Observable<T> {
    var clousre: ((T)->Void)?
    
    var value: T {
        didSet {
            self.clousre?(self.value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    func bind(clousre: @escaping (T) -> Void) {
        clousre(value)
        self.clousre = clousre
    }
}
