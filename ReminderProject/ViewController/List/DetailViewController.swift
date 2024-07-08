//
//  DetailViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/4/24.
//

import UIKit
import SnapKit
import RealmSwift

final class DetailViewController: BaseViewController {
    
    var getId = ObjectId()
    private let realm = try! Realm()
    let memoTitleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    let memoLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35)
        return label
    }()
    let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    let tagLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .systemBlue
        return label
    }()
    private let editMemoTitleTextField = {
        let text = UITextField()
        text.placeholder = "제목"
        return text
    }()
    private let editMemoTextField = {
        let text = UITextField()
        text.placeholder = "메모"
        return text
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationButtonSetting()
    }
    private func navigationButtonSetting() {
        navigationItem.title = "상세화면"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editButtonTapped))
    }
    @objc func editButtonTapped() {
        let result = realm.objects(RealmTable.self).filter("key == %@", getId)
        guard let memoTitle = editMemoTitleTextField.text,
              let memo = editMemoTextField.text else { return }
        if memoTitle.isEmpty && memo.isEmpty {
            showAlert(title: "공백", message: "")
        } else if memoTitle.isEmpty && !memo.isEmpty {
            try! realm.write {
                result.setValue(memo, forKey: "\(MemoContents.memo.rawValue)")
            }
            memoLabel.text = memo
        } else if !memoTitle.isEmpty && memo.isEmpty {
            try! realm.write {
                result.setValue(memoTitle, forKey: "\(MemoContents.memoTitle.rawValue)")
            }
            memoTitleLabel.text = memoTitle
        } else {
            try! realm.write {
                result.setValue(memoTitle, forKey: "\(MemoContents.memoTitle.rawValue)")
                result.setValue(memo, forKey: "\(MemoContents.memo.rawValue)")
            }
            memoTitleLabel.text = memoTitle
            memoLabel.text = memo
        }
        
    }
    override func viewDidLayoutSubviews() {
        editMemoTitleTextField.layer.addBorder([.bottom], color: .darkGray, width: 1)
        editMemoTextField.layer.addBorder([.bottom], color: .darkGray, width: 1)
    }
    override func configureHierarchy() {
        view.addSubview(memoTitleLabel)
        view.addSubview(memoLabel)
        view.addSubview(dateLabel)
        view.addSubview(tagLabel)
        view.addSubview(editMemoTitleTextField)
        view.addSubview(editMemoTextField)
    }
    override func configureLayout() {
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.equalTo(memoTitleLabel.snp.trailing).offset(20)
        }
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        editMemoTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        editMemoTextField.snp.makeConstraints { make in
            make.top.equalTo(editMemoTitleTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}

