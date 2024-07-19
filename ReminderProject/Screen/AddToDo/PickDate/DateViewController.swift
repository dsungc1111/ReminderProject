//
//  DateViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//


import UIKit

final class DateViewController: BaseViewController {
   
    let viewModel = DateViewModel()
    
    private let datePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        return picker
    }()
    private let showDateLabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func bindData() {
        viewModel.outputPickDate.bind { [weak self] _ in
            self?.showDateLabel.text = self?.viewModel.outputPickDate.value
        }
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
    override func addActions() {
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(completebuttonTapped))
    }
    
    @objc func dateChange(_ sender: UIDatePicker) {
        viewModel.inputPickDate.value = sender.date
    }
    @objc func completebuttonTapped() {
        viewModel.inputCompletionButtonTapped.value = ()
        self.navigationController?.popViewController(animated: true)
    }
    
}
