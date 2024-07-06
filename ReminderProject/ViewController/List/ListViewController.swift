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
    private let realm = try! Realm()
    private lazy var removeAllButton = {
       let btn = UIButton()
        btn.setTitle("전체 삭제", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(removeAllButtonTapped), for: .touchUpInside)
        return btn
    }()
    @objc func removeAllButtonTapped() {
        print(#function)
//        let filter = realm.objects(RealmTable.self).where {
//            $0.memoTitle.contains("", options: .caseInsensitive)
//        }
//        DataList.list.realm?.deleteAll()
//        let result = filter
//        DataList.list = result
        try! self.realm.write {
            DataList.list.realm?.deleteAll()
            }
            
        
        tableView.reloadData()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationbarSetting()
    }
    private func navigationbarSetting() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SortButtonImages.ellipsis.rawValue), style: .plain, target: self, action: nil)
        
        let memoTitle = UIAction(title: SortButtonTitle.sortByTitle.rawValue, image: UIImage(systemName: SortButtonImages.lineweight.rawValue), handler: { _ in self.sortByTitleButtonTapped() })
        let memoContent = UIAction(title: SortButtonTitle.sortByContent.rawValue, image: UIImage(systemName: SortButtonImages.note.rawValue), handler: { _ in self.sortByContentButtonTapped() })
        let memoDate = UIAction(title: SortButtonTitle.sortByTime.rawValue, image: UIImage(systemName: SortButtonImages.calender.rawValue), handler: { _ in self.sortByDateButtonTapped() })

        navigationItem.rightBarButtonItem?.menu = UIMenu(title: SortButtonTitle.sortButton.rawValue, options: .displayInline, children: [memoTitle, memoContent, memoDate])
    }
    
    private func sortByTitleButtonTapped() {
        DataList.list = DataList.list.sorted(byKeyPath: MemoContents.memoTitle.rawValue)
        tableView.reloadData()
    }
    private func sortByContentButtonTapped() {
        DataList.list = DataList.list.sorted(byKeyPath: MemoContents.memo.rawValue)
        tableView.reloadData()
    }
    private func sortByDateButtonTapped() {
        DataList.list = DataList.list.sorted(byKeyPath: MemoContents.date.rawValue)
        tableView.reloadData()
    }
    override func tableViewSetting() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        tableView.backgroundColor = .clear
    }
    override func configureHierarchy() {
        view.addSubview(removeAllButton)
        view.addSubview(tableView)
    }
    override func configureLayout() {
        removeAllButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(removeAllButton.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
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
