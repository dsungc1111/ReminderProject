//
//  DateViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit

class DateViewController: BaseViewController {

    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    var passDate: PassDateDelegate?
    var getDateFromDatePicker = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        passDate?.passDateValue(getDateFromDatePicker)
    }
    @objc func dateChange(_ sender: UIDatePicker) {
        getDateFromDatePicker = dateFormat(date: sender.date)
    }
    private func dateFormat(date: Date) -> String {
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyy.MM.dd E요일"
        return dateFormatter.string(from: date)
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
