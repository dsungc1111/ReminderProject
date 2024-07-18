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
        configureNavigationbar()
        bindData()
        setCollectionView()
        addActions()
    }
    func bindData() {}
    func configureNavigationbar() {}
    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}
    func setCollectionView() {}
    func addActions() {}
    
}
