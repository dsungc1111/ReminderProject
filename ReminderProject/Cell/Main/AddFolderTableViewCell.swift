//
//  AddListTableViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/8/24.
//

import UIKit
import SnapKit


final class AddFolderTableViewCell: BaseTableViewCell {

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
    let numberOfContentsLabel = {
       let label = UILabel()
        label.text = "0"
        label.textColor = .lightGray
        return label
    }()
    let enterButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(contentLogo)
        contentView.addSubview(contentName)
        contentView.addSubview(numberOfContentsLabel)
        contentView.addSubview(enterButton)
    }
    override func configureLayout() {
        contentLogo.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(30)
        }
        contentName.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentLogo.snp.trailing).offset(20)
        }
        enterButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
        numberOfContentsLabel.snp.makeConstraints { make in
            make.trailing.equalTo(enterButton.snp.leading).offset(-5)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    func configureCell(data: Folder) {
        contentName.text = data.category
        numberOfContentsLabel.text = "\(data.content.count)" + "개"
    }
}
