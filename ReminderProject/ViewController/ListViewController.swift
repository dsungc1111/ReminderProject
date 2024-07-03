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
        list = realm.objects(RealmTable.self).sorted(byKeyPath: MemoContents.memoTitle.rawValue , ascending: true)
        navigationbarSetting()
    }
    private func navigationbarSetting() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SortButtonImages.ellipsis.rawValue), style: .plain, target: self, action: nil)
        
        let memoTitle = UIAction(title: SortButtonTitle.sortByTitle.rawValue, image: UIImage(systemName: SortButtonImages.lineweight.rawValue), handler: { _ in self.sortByTitleButtonTapped() })
        let memoContent = UIAction(title: SortButtonTitle.sortByContent.rawValue, image: UIImage(systemName: SortButtonImages.note.rawValue), handler: { _ in self.sortByContentButtonTapped() })
        let memoDate = UIAction(title: SortButtonTitle.sortByTime.rawValue, image: UIImage(systemName: SortButtonImages.calender.rawValue), handler: { _ in self.sortByDateButtonTapped() })

        navigationItem.rightBarButtonItem?.menu = UIMenu(title: SortButtonTitle.sortButton.rawValue, options: .displayInline, children: [memoTitle, memoContent, memoDate])
    }
    
    private func sortByTitleButtonTapped() {
        list = realm.objects(RealmTable.self).sorted(byKeyPath: MemoContents.memoTitle.rawValue, ascending: true)
        tableView.reloadData()
    }
    private func sortByContentButtonTapped() {
        list = realm.objects(RealmTable.self).sorted(byKeyPath: MemoContents.memo.rawValue, ascending: true)
        tableView.reloadData()
    }
    private func sortByDateButtonTapped() {
        list = realm.objects(RealmTable.self).sorted(byKeyPath: MemoContents.date.rawValue, ascending: true)
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
        cell.dueDateLabel.text =  data.date
        if let tag = data.tag { cell.tagLabel.text = tag }
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
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            try! self.realm.write {
                self.realm.delete(self.list[indexPath.row])
            }
            tableView.reloadData()
            success(true)
        }
        delete.backgroundColor = .systemRed
        let fix = UIContextualAction(style: .normal, title: "고정") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("fix clicked")
            success(true)
        }
        fix.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions:[delete, fix])
    }
}
