//
//  DateViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit

final class DateViewController: BaseViewController {

    private let datePicker = UIDatePicker()
    var passDate: PassDateDelegate?
    var getDateFromDatePicker: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(completebuttonTapped))
    }
    @objc func completebuttonTapped() {
        passDate?.passDateValue(getDateFromDatePicker ?? Date())
        navigationController?.popViewController(animated: true)
    }
    @objc func dateChange(_ sender: UIDatePicker) {
        getDateFromDatePicker = sender.date
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
