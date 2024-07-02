//
//  RegisterTableViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit

class CategoryTableViewCell: BaseTableViewCell {

    
    let backView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    let titleLabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    let clickButton = {
        let btn = UIButton()
        btn.tintColor = .darkGray
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return btn
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(backView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(clickButton)
    }
    
    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.leading).inset(20)
            make.verticalEdges.equalTo(backView.snp.verticalEdges).inset(5)
        }
        clickButton.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.trailing).inset(20)
            make.verticalEdges.equalTo(backView.snp.verticalEdges).inset(5)
        }
    }
    override func configureCell() {
        backgroundColor = .clear
    }

    

}
