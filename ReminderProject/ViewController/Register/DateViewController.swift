//
//  DateViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit

class DateViewController: BaseViewController {

    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
