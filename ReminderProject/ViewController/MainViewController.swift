//
//  MainViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {

    private lazy var addButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = .black
        btn.setTitle(" 새로운 일 추가", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var temporaryButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("임시버튼 > 리스트", for: .normal)
        btn.addTarget(self, action: #selector(temporaryButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @objc func temporaryButtonTapped() {
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addButtonTapped() {
        let vc = UINavigationController(rootViewController: RegisterViewController())
        navigationController?.present(vc, animated: true)
    }
    override func configureHierarchy() {
        view.addSubview(addButton)
        view.addSubview(temporaryButton)
    }
    override func configureLayout() {
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        temporaryButton.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
}
