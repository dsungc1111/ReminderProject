//
//  TodoTableViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit

final class TodoTableViewCell: BaseTableViewCell {

    let backView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleTextField = {
        let text = UITextField()
        text.placeholder = "제목"
        text.frame.size.width = 353
        text.frame.size.height = 60
        text.layer.addBorder([.bottom], color: .systemGray5, width: 1)
        return text
    }()
    let memoTextField = {
        let text = UITextField()
        text.placeholder = "메모"
        return text
    }()
    
    
    override func configureHierarchy() {
        contentView.addSubview(backView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(memoTextField)
    }
    
    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).inset(5)
            make.horizontalEdges.equalTo(backView.snp.horizontalEdges).inset(20)
            make.height.equalTo(70)
        }
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(5)
            make.leading.equalTo(backView.snp.leading).inset(20)
            make.trailing.equalTo(backView.snp.trailing)
            make.bottom.equalTo(backView.snp.bottom).inset(5)
        }
    }
    override func configureCell() {
        backView.backgroundColor = .white
    }

}
