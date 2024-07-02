//
//  AddedTableViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import RealmSwift


final class ListTableViewCell: BaseTableViewCell {

    private let circleButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "circle"), for: .normal)
        return btn
    }()
    let titleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    let contentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    let dueDateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(circleButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dueDateLabel)
    }
    override func configureLayout() {
        circleButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(circleButton.snp.trailing).offset(10)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(circleButton.snp.trailing).offset(10)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalTo(circleButton.snp.trailing).offset(10)
        }
    }

}
