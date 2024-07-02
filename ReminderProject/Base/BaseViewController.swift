//
//  BaseViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        configureHierarchy()
        configureLayout()
        configureView()
        tableViewSetting()
    }
    func tableViewSetting() {}
    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}

}
