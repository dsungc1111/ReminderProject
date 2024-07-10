//
//  AddedTableViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ListTableViewCell: BaseTableViewCell {
    
     var completeButton = {
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
    let tagLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemBlue
        return label
    }()
    let flagLogoView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(systemName: ContentLogoImageEnum.flag.rawValue)
        view.tintColor = .systemYellow
        return view
    }()
    override func configureHierarchy() {
        contentView.addSubview(completeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(flagLogoView)
    }
    override func configureLayout() {
        completeButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(completeButton.snp.trailing).offset(10)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(completeButton.snp.trailing).offset(10)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalTo(completeButton.snp.trailing).offset(10)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalTo(dueDateLabel.snp.trailing).offset(5)
        }
        flagLogoView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(30)
            make.size.equalTo(30)
        }
    }
    func configureCell(data: RealmTable) {
        titleLabel.text = data.memoTitle
        contentLabel.text = data.memo
        dueDateLabel.text =  Date.getDateString(date: data.date ?? Date())
        if let tag = data.tag { tagLabel.text = tag }
        if data.isFlag == false {
            flagLogoView.isHidden = true
        } else {
            flagLogoView.isHidden = false
        }
    }
}