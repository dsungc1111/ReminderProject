//
//  ListViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ListViewController: BaseViewController {
    
    private let tableView = UITableView()
    private let dateFormatter = DateFormatter()
    
    private let realm = try! Realm()
    private var list: Results<RealmTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(RealmTable.self).sorted(byKeyPath: "memoTitle", ascending: true)
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
      tableViewSetting()
    }
    private func tableViewSetting() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        tableView.backgroundColor = .clear
    }
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return ListTableViewCell() }
        let data = list[indexPath.row]
        cell.titleLabel.text = data.memoTitle
        cell.contentLabel.text = data.memo
        cell.dueDateLabel.text = dateToString(date: data.date!)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    private func dateToString(date: Date) -> String {
        dateFormatter.dateFormat = "yy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
}
