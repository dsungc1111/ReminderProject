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
    private let showDateLabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    let viewModel = DateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        addActions()
        bindData()
    }
    // pick이 바뀔 때
    func bindData() {
        viewModel.pickDate.bind { _ in
            if let getDate = self.viewModel.pickDate.value {
                self.showDateLabel.text = Date.getDateString(date: getDate)
            }
        }
    }
    func addActions() {
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(completebuttonTapped))
    }
    
    
    @objc func dateChange(_ sender: UIDatePicker) {
        viewModel.pickDate.value = sender.date
    }
    
    @objc func completebuttonTapped() {
        passDate?.passDateValue(viewModel.pickDate.value ?? Date())
        navigationController?.popViewController(animated: true)
    }
    override func configureHierarchy() {
        view.addSubview(datePicker)
        view.addSubview(showDateLabel)
    }
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        showDateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
    }
}
