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
    static var totalCount = 0
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
        if data.row == 2 {
            contentCountLabel.text = "\(list.count)"
        }
        if data.row == 4{
            contentCountLabel.text = ""
        }
    }
}
