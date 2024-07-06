//
//  SearchViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/6/24.
//

import UIKit
import SnapKit
import RealmSwift

final class SearchViewController: BaseViewController {

    private lazy var searchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "검색"
        search.backgroundColor = .clear
        search.barTintColor = .systemGray6
        search.searchTextField.backgroundColor = .white
        return search
    }()
    private lazy var tableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        return table
    }()
    private let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        DataList.list = realm.objects(RealmTable.self).filter("isComplete == true")
    }
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = realm.objects(RealmTable.self).where {
            $0.memoTitle.contains(searchText, options: .caseInsensitive)
        }
        let result = filter
        DataList.list = result
        tableView.reloadData()
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "검색결과 \(DataList.list.count)개"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataList.list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return ListTableViewCell() }
        let data = DataList.list[indexPath.row]
        cell.completeButton.tag = indexPath.row
        let image = data.isComplete ? "circle.fill" : "circle"
        cell.completeButton.setImage(UIImage(systemName: image), for: .normal)
        cell.completeButton.addTarget(self, action: #selector(completeButtonTapped(sender:)), for: .touchUpInside)
        cell.configureCell(data: data)
        return cell
    }
    @objc func completeButtonTapped(sender: UIButton) {
        let complete = DataList.list[sender.tag]
        try! self.realm.write {
            complete.isComplete.toggle()
            self.realm.create(RealmTable.self, value: ["key" : complete.key, "isComplete" : complete.isComplete], update: .modified)
            let image = complete.isComplete ? "circle.fill" : "circle"
            sender.setImage(UIImage(systemName: image), for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 ) {
        try! self.realm.write {
                self.realm.delete(complete)
            }
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let vc = DetailViewController()
        vc.memoTitleLabel.text = DataList.list[indexPath.row].memoTitle
        if DataList.list[indexPath.row].priority == "높음" {
            vc.memoTitleLabel.text = "!!!" + DataList.list[indexPath.row].memoTitle
        }
        vc.memoLabel.text = DataList.list[indexPath.row].memo
        vc.dateLabel.text = Date.getDateString(date: DataList.list[indexPath.row].date ?? Date())
        vc.tagLabel.text = "#\(DataList.list[indexPath.row].tag ?? "")"
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            try! self.realm.write {
                self.realm.delete(DataList.list[indexPath.row])
            }
            tableView.reloadData()
            success(true)
        }
        delete.backgroundColor = .systemRed
        let flag = UIContextualAction(style: .normal, title: "깃발") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            try! self.realm.write {
                DataList.list[indexPath.row].isFlag.toggle()
                self.realm.create(RealmTable.self, value: ["key" : DataList.list[indexPath.row].key, "isFlag" : DataList.list[indexPath.row].isFlag], update: .modified)
            }
            tableView.reloadData()
            success(true)
        }
        flag.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions:[delete, flag])
    }
}
