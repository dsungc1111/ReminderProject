//
//  SearchViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/6/24.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {

    private enum SwipeButtonTitle: String {
        case flag = "깃발"
        case delete = "삭제"
    }
    private let repository = RealmTableRepository()
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
    private let viewModel = SearchViewModel()
    private var list: [RealmTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        list = repository.fetchRealmTable()
        bindData()
    }
    func bindData() {
        viewModel.outputList.bind { _ in
            self.list = self.viewModel.outputList.value ?? [RealmTable]()
            self.tableView.reloadData()
        }
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
        viewModel.inputSearchText.value = searchText
        viewModel.inputSearchTextChange.value = ()
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "검색결과 \(list.count)개"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return ListTableViewCell() }
        let data = list[indexPath.row]
        cell.completeButton.tag = indexPath.row
        let image = data.isComplete ? "circle.fill" : "circle"
        cell.completeButton.setImage(UIImage(systemName: image), for: .normal)
        cell.completeButton.addTarget(self, action: #selector(completeButtonTapped(sender:)), for: .touchUpInside)
        cell.configureCell(data: data)
        return cell
    }
    @objc func completeButtonTapped(sender: UIButton) {
        let image = self.viewModel.completeButtonTapped(list: self.list, index: sender.tag)
        sender.setImage(UIImage(systemName: image), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 ) {
            self.viewModel.deleteToDo(list: self.list, index: sender.tag)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let vc = DetailViewController()
        vc.memoTitleLabel.text = list[indexPath.row].memoTitle
        vc.memoTitleLabel.text = repository.selectedPrioprity(list: list[indexPath.row])
        vc.memoLabel.text = list[indexPath.row].memo
        vc.dateLabel.text = Date.getDateString(date: list[indexPath.row].date ?? Date())
        if let tag = list[indexPath.row].tag,
            !tag.isEmpty {
            vc.tagLabel.text = "#" + tag
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: SwipeButtonTitle.delete.rawValue) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.viewModel.deleteToDo(list: self.list, index: indexPath.row)
            success(true)
        }
        delete.backgroundColor = .systemRed
        let flag = UIContextualAction(style: .normal, title: SwipeButtonTitle.flag.rawValue) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.viewModel.changeFlag(list: self.list, index: indexPath.row)
            success(true)
        }
        flag.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions:[delete, flag])
    }
}
