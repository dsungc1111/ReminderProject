//
//  MainCollectionViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit
import SnapKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    let repository = RealmTableRepository()
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
        return name
    }()
    var contentCountLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    var listTitle: [Folder] = []
    private var list: [RealmTable] = []
    
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(data: IndexPath) {
        contentName.text = ContentNameEnum.allCases[data.row].rawValue
        contentLogo.backgroundColor =  ContentLogoColorEnum.allCases[data.row].value
        contentLogo.image = UIImage(systemName: ContentLogoImageEnum.allCases[data.row].rawValue)
        list = repository.fetchCategory(cases: data.row)
        contentCountLabel.text = data.row <= 3 ? "\(list.count)" : ""
    }
}
