//
//  ListSelectViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/8/24.
//

import UIKit
import SnapKit

final class FolderListViewController: BaseViewController {

    private var listTitle: [Folder] = []
    let viewModel = FolderViewModel()
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

    }
    override func bindData() {
        viewModel.outputListTitle.bind { value in
            self.listTitle = value
        }
        viewModel.outputSelectedFolder.bindLater { _ in
            self.navigationController?.popViewController(animated: true)
        }
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
extension FolderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.id, for: indexPath) as? FolderTableViewCell else { return FolderTableViewCell() }
        cell.contentName.text = listTitle[indexPath.row].category
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputSelectedFolder.value = listTitle[indexPath.row]
        viewModel.outputSelectedFolder.value = ()
    }
}
