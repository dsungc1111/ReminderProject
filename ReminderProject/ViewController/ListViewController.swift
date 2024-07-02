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
        navigationbarSetting()
    }
    private func navigationbarSetting() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        
        let memoTitle = UIAction(title: "제목순", image: UIImage(systemName: "lineweight"), handler: { _ in self.sortByTitleButtonTapped() })
        let memoContent = UIAction(title: "메모순", image: UIImage(systemName: "note"), handler: { _ in self.sortByContentButtonTapped() })
        let memoDate = UIAction(title: "날짜순", image: UIImage(systemName: "calendar.badge.clock"), handler: { _ in self.sortByDateButtonTapped() })

        navigationItem.rightBarButtonItem?.menu = UIMenu(title: "정렬", options: .displayInline, children: [memoTitle, memoContent, memoDate])
    }
    
    func sortByTitleButtonTapped() {
        list = realm.objects(RealmTable.self).sorted(byKeyPath: "memoTitle", ascending: true)
        tableView.reloadData()
    }
    func sortByContentButtonTapped() {
        list = realm.objects(RealmTable.self).sorted(byKeyPath: "memo", ascending: true)
        tableView.reloadData()
    }
    func sortByDateButtonTapped() {
        list = realm.objects(RealmTable.self).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    override func tableViewSetting() {
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
        dateFormatter.dateFormat = "yy년 MM월 dd일 HH시 mm분"
        return dateFormatter.string(from: date)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
    }
}
