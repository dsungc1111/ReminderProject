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
        case star = "중요"
        case delete = "삭제"
    }
    var list: [RealmTable] = []
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
        // 정렬버튼
        renewValue(list: viewModel.outputSortList)
        // isComplete == false
        // Reamltable 삭제
        renewValue(list: viewModel.outputDeleteInfo)
        // 깃발 > 중요
        renewValue(list: viewModel.outputStarList)
        renewValue(list: viewModel.outputCompleteButton)
        renewValue(list: viewModel.outputFilteredReloadList)
    }
    private func renewValue(list: Observable<[RealmTable]?>) {
        list.bindLater { value in
            guard let value = value else { return }
            self.list = value
            self.tableView.reloadData()
        }
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
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "결과 \(list.count)개"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return ListTableViewCell() }
        let data = list[indexPath.row]
        cell.completeButton.tag = indexPath.row
        cell.completeButton.addTarget(self, action: #selector(completeButtonTapped(sender:)), for: .touchUpInside)
        cell.configureCell(data: data)
        return cell
    }
    @objc func completeButtonTapped(sender: UIButton) {
        viewModel.inputCompleteButton.value = [list: sender.tag]
//        let image = viewModel.outputCompleteButton.value
//        sender.setImage(UIImage(systemName: image), for: .normal)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.viewModel.inputFilteredReloadList.value = ()
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let vc = DetailViewController()
        vc.memoTitleLabel.text = list[indexPath.row].memoTitle
        viewModel.inputPriority.value = list[indexPath.row]
        vc.memoTitleLabel.text = viewModel.outputPriority.value
        vc.memoLabel.text = list[indexPath.row].memo
        vc.dateLabel.text = Date.getDateString(date: list[indexPath.row].date ?? Date())
        if let tag = list[indexPath.row].tag,
            !tag.isEmpty {
            vc.tagLabel.text = "#" + tag
        }
        vc.viewModel.getId = list[indexPath.row].key
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: SwipeButtonTitle.delete.rawValue) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.viewModel.inputDeleteInfo.value = [self.list : indexPath.row]
            success(true)
        }
        delete.backgroundColor = .systemRed
        let star = UIContextualAction(style: .normal, title: SwipeButtonTitle.star.rawValue) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.viewModel.inputStarList.value = [self.list : indexPath.row]
            success(true)
        }
        star.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions:[delete, star])
    }
}
