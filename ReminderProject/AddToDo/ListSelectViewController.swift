//
//  ListSelectViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/8/24.
//

import UIKit
import RealmSwift
import SnapKit

final class ListSelectViewController: BaseViewController {

    let realm = try! Realm()
    var listTitle: Results<Folder>!
    var passFolder: PassDateDelegate?
    lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(FolderTableViewCell.self, forCellReuseIdentifier: FolderTableViewCell.id)
        view.backgroundColor = .clear
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listTitle = realm.objects(Folder.self)
    }
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

}
extension ListSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.id, for: indexPath) as? FolderTableViewCell else { return FolderTableViewCell() }
        cell.contentName.text = listTitle[indexPath.row].category
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passFolder?.passList(listTitle[indexPath.row].category)
        navigationController?.popViewController(animated: true)
    }
}
