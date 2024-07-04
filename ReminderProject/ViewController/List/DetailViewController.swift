//
//  DetailViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/4/24.
//

import UIKit
import SnapKit

class DetailViewController: BaseViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func configureHierarchy() {
        view.addSubview(memoTitleLabel)
        view.addSubview(memoLabel)
        view.addSubview(dateLabel)
        view.addSubview(tagLabel)
    }
    override func configureLayout() {
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
