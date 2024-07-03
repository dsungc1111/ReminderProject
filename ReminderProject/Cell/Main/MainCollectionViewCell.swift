//
//  MainCollectionViewCell.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit
import SnapKit
import RealmSwift

class MainCollectionViewCell: UICollectionViewCell {
    
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
    var contentCountLabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    private let realm = try! Realm()
    private var list: Results<RealmTable>!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        configureHierarchy()
        configureLayout()
        contentLogo.layer.cornerRadius = 15
        list = realm.objects(RealmTable.self).sorted(byKeyPath: MemoContents.memoTitle.rawValue , ascending: true)
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
        let date = Date()
        switch data.row {
        case 0:
            ListViewController.list = realm.objects(RealmTable.self).filter("date == %@", date)
            contentCountLabel.text = "\( ListViewController.list.count)"
        case 1:
            ListViewController.list = realm.objects(RealmTable.self).filter("date > %@", date)
            contentCountLabel.text = "\( ListViewController.list.count)"
        case 2:
            ListViewController.list = realm.objects(RealmTable.self).sorted(byKeyPath: MemoContents.memoTitle.rawValue , ascending: true)
            contentCountLabel.text = "\( ListViewController.list.count)"
        case 3:
            contentCountLabel.text = "\( ListViewController.list.count)"
        case 4:
            contentCountLabel.text = ""
        default:
            break
        }
        
    }
}
