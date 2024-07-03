//
//  MainCollectionViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit
import SnapKit


class MainCollectionViewCell: UICollectionViewCell {
    
    enum ContentNameEnum: String, CaseIterable {
        case today = "오늘"
        case plan = "예정"
        case all = "전체"
        case flag = "깃발 표시"
        case complete = "완료됨"
    }
    enum ContentLogoImageEnum: String, CaseIterable {
        case today = "arrowshape.right.circle"
        case plan = "calendar.circle"
        case all = "tray.circle"
        case flag = "flag.circle"
        case complete = "checkmark.circle.fill"
    }
    let contentLogo = {
        let logo = UIImageView()
        logo.backgroundColor = .black
        logo.contentMode = .center
        logo.tintColor = .white
        return logo
    }()
    let contentName = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 15)
        name.textColor = .darkGray
        name.text = "df"
        return name
    }()
    let contentCountLabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        configureHierarchy()
        configureLayout()
        contentLogo.layer.cornerRadius = 15
    }
    func configureHierarchy() {
        contentView.addSubview(contentLogo)
        contentView.addSubview(contentName)
        contentView.addSubview(contentCountLabel)
    }
    func configureLayout() {
        contentLogo.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(30)
        }
        contentName.snp.makeConstraints { make in
            make.top.equalTo(contentLogo.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(11)
        }
        contentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentLogo.layoutIfNeeded()
//        
////        contentLogo.frame.size.width = 30
////        contentLogo.frame.size.height = 30
////        contentLogo.layer.cornerRadius = 15
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(data: IndexPath) {
        contentName.text = ContentNameEnum.allCases[data.row].rawValue
        contentLogo.backgroundColor =  ContentLogoColorEnum.allCases[data.row].value
        contentLogo.image = UIImage(systemName: ContentLogoImageEnum.allCases[data.row].rawValue)
        if data.row == 4{
            contentCountLabel.text = ""
        }
    }
}
