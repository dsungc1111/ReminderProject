//
//  TodoTableViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit

class TodoTableViewCell: BaseTableViewCell {

    let backView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    override func configureHierarchy() {
        contentView.addSubview(backView)
    }
    
    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    override func configureCell() {
        backView.backgroundColor = .white
        backgroundColor = .clear
    }

}
