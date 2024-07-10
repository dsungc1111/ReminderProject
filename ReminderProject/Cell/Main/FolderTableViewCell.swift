//
//  ListSelectTableViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/8/24.
//

import UIKit

class FolderTableViewCell: BaseTableViewCell {

    let contentLogo = {
        let logo = UIImageView()
        logo.contentMode = .center
        logo.tintColor = .systemBlue
        logo.image = UIImage(systemName: "list.bullet.circle.fill")
        logo.contentMode = .scaleAspectFill
        return logo
    }()
    let contentName = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 15)
        name.textColor = .darkGray
        name.text = "df"
        return name
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(contentLogo)
        contentView.addSubview(contentName)
    }
    override func configureLayout() {
        contentLogo.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(40)
        }
        contentName.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentLogo.snp.trailing).offset(10)
        }
    }

}
