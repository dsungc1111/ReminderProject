//
//  ListViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit


final class ListViewController: BaseViewController {
    private enum SwipeButtonTitle: String {
        case flag = "깃발"
        case delete = "삭제"
    }
    var toDoList: [RealmTable] = []
    var folderList: [Folder] = []
    let viewModel = ListViewModel()
    lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        view.backgroundColor = .clear
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationbarSetting()
        bindData()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    private func bindData() {
        //        viewModel.outputToDoTrigger.bind { value in
        //            self.toDoList = value
        //        }
//        viewModel.outputFolderTrigger.bind { value in
//            self.folderList = value
//        }
        renewValue(list: viewModel.outputDeleteAll)
        renewValue(list: viewModel.outputSortList)
        renewValue(list: viewModel.outputReloadList)
        renewValue(list: viewModel.outputDeleteInfo)
        renewValue(list: viewModel.outputFlagList)
    }
    private func renewValue(list: Observable<[RealmTable]?>) {
        list.bindLater { value in
            guard let value = value else { return }
            self.toDoList = value
            self.tableView.reloadData()
        }
    }
    @objc func removeAllButtonTapped() {
        viewModel.inputDeleteAll.value = ()
    }
    private func navigationbarSetting() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SortButtonImages.ellipsis.rawValue), style: .plain, target: self, action: nil)
        let memoTitle = UIAction(title: SortButtonTitle.sortByTitle.rawValue, image: UIImage(systemName: SortButtonImages.lineweight.rawValue), handler: { _ in self.sortButtonTapped(index: 0) })
        let memoContent = UIAction(title: SortButtonTitle.sortByContent.rawValue, image: UIImage(systemName: SortButtonImages.note.rawValue), handler: { _ in self.sortButtonTapped(index: 1) })
        let memoDate = UIAction(title: SortButtonTitle.sortByTime.rawValue, image: UIImage(systemName: SortButtonImages.calender.rawValue), handler: { _ in self.sortButtonTapped(index: 2) })
        navigationItem.rightBarButtonItem?.menu = UIMenu(title: SortButtonTitle.sortButton.rawValue, options: .displayInline, children: [memoTitle, memoContent, memoDate])
    }
    private func sortButtonTapped(index: Int) {
        viewModel.inputSortIndex.value = index
    }
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return folderList.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return folderList[section].category
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if folderList[section].content.count != 0 {
            return folderList[section].content.count
        } else {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if folderList[indexPath.section].content.count != 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return ListTableViewCell() }
            let data = folderList[indexPath.section].content[indexPath.row]
                    cell.configureCell(data: data)
            cell.completeButton.tag = indexPath.row
            cell.completeButton.addTarget(self, action: #selector(completeButtonTapped(sender:)), for: .touchUpInside)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return ListTableViewCell() }
            cell.completeButton.setImage(UIImage(systemName: "circle.dotted"), for: .normal)
            cell.titleLabel.text = "00"
            return cell
        }
    }
    @objc func completeButtonTapped(sender: UIButton) {
        viewModel.inputCompleteButton.value = [toDoList: sender.tag]
        guard let image = viewModel.outputCompleteButton.value else { return }
        sender.setImage(UIImage(systemName: image), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
            self.viewModel.inputReloadList.value = sender.tag
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let vc = DetailViewController()
        vc.memoTitleLabel.text = toDoList[indexPath.row].memoTitle
        viewModel.inputPriority.value = toDoList[indexPath.row]
        vc.memoTitleLabel.text = viewModel.outputPriority.value
        vc.memoLabel.text = toDoList[indexPath.row].memo
        vc.dateLabel.text = Date.getDateString(date: toDoList[indexPath.row].date ?? Date())
        if let tag = toDoList[indexPath.row].tag,
           !tag.isEmpty {
            vc.tagLabel.text = "#" + tag
        }
        vc.viewModel.getId = toDoList[indexPath.row].key
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: SwipeButtonTitle.delete.rawValue) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.viewModel.inputDeleteInfo.value = [self.toDoList : indexPath.row]
            success(true)
        }
        delete.backgroundColor = .systemRed
        let flag = UIContextualAction(style: .normal, title: SwipeButtonTitle.flag.rawValue) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.viewModel.inputFlagList.value = [self.toDoList : indexPath.row]
            success(true)
        }
        flag.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions:[delete, flag])
    }
}
