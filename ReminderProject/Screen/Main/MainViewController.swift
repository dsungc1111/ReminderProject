//
//  MainViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import IQKeyboardManagerSwift
import SnapKit
import Toast

final class MainViewController: BaseViewController {
   
    
    deinit {
        print("========MainViewController Deinit============")
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (sectionSpacing*2 + cellSpacing*2)
        layout.itemSize = CGSize(width: width/2, height: width/4 + cellSpacing)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    private lazy var addToDoButton = { [weak self] in
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.setTitle(" 새로운 일 추가", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(self?.addToDoButtonTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var listAddButton = { [weak self] in
        let btn = UIButton()
        btn.setTitle("목록추가", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(self?.listAddButtonTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(AddFolderTableViewCell.self, forCellReuseIdentifier: AddFolderTableViewCell.id)
        view.layer.cornerRadius = 10
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        view.estimatedRowHeight = 50
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    private let myListLabel = {
        let label = UILabel()
        label.text = "나의 목록"
        label.font = .boldSystemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()
    private let date = Date()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let tabBarView = UIView()
    
    private let viewModel = MainViewModel()
    private var listTitle: [Folder] = []
    private var toDoList: [RealmTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .always
        collectionView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.layer.addBorder([.bottom], color: .systemGray4, width: 1)
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.popViewController(animated: true)
    }
    
    override func bindData() {
        viewModel.setListTitleTrigger.bind { [weak self] value in
            self?.listTitle = value
            self?.myListLabel.isHidden = self?.listTitle.count != 0 ? false : true
            self?.tableView.reloadData()
            self?.configureContentView()
        }
        viewModel.outputDeleteInfo.bindLater { [weak self] value in
            self?.listTitle = value
            self?.tableView.reloadData()
            self?.configureContentView()
        }
    }
    
    override func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
    }
    override func configureNavigationbar() {
        navigationItem.title = "미리알림"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
    }
    override func configureHierarchy() {
        view.addSubview(scrollView)
        view.addSubview(tabBarView)
        scrollView.addSubview(contentView)
        contentView.addSubview(collectionView)
        contentView.addSubview(myListLabel)
        contentView.addSubview(tableView)
        tabBarView.addSubview(addToDoButton)
        tabBarView.addSubview(listAddButton)
    }
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(tabBarView.snp.top)
        }
        tabBarView.backgroundColor = .systemGray6
        tabBarView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        addToDoButton.snp.makeConstraints { make in
            make.bottom.equalTo(tabBarView).inset(20)
            make.leading.equalTo(tabBarView).inset(25)
            make.height.equalTo(30)
        }
        listAddButton.snp.makeConstraints { make in
            make.bottom.equalTo(tabBarView).inset(20)
            make.trailing.equalTo(tabBarView)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
    }
    
    func configureContentView() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(20)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(360)
        }
        myListLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.leading.equalTo(contentView).inset(20)
        }
        tableView.snp.updateConstraints { make in
            make.top.equalTo(myListLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(contentView).inset(20)
            make.height.greaterThanOrEqualTo(50*listTitle.count)
        }
    }
    
    @objc func searchButtonTapped() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func calendarButtonTapped() {
        let vc = CalendarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func listAddButtonTapped() {
        let vc = AddFolderViewController()
        vc.showToast = { [weak self] in
            self?.view.makeToast("저장완료!")
        }
        vc.viewModel.passFolder = self
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.present(nav, animated: true)
    }
    @objc func addToDoButtonTapped() {
        let vc = AddToDoViewController()
        vc.showToast = { [weak self] in
            self?.view.makeToast("저장완료!")
        }
        vc.viewModel.passData = self
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.present(nav, animated: true)
    }
}
extension MainViewController:  PassDataDelegate, PassFolderDelegate {
    func passFolderList(_ dataList: [Folder]) { 
        listTitle = dataList
        myListLabel.isHidden = self.listTitle.count != 0 ? false : true
        tableView.reloadData()
        configureContentView()
    }
    func passDataList(_ dataList: [RealmTable]) {
        toDoList = dataList
        collectionView.reloadData()
        tableView.reloadData()
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as? MainCollectionViewCell else { return MainCollectionViewCell() }
        cell.listTitle = listTitle
        cell.configureCell(data: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ListViewController()
        vc.navigationItem.title = ContentNameEnum.allCases[indexPath.item].rawValue
        viewModel.inputPassList.value = indexPath.item
        vc.list = viewModel.outputPassList.value
        vc.viewModel.getPageNumber = indexPath.item
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddFolderTableViewCell.id, for: indexPath) as? AddFolderTableViewCell else { return AddFolderTableViewCell() }
        cell.configureCell(data: listTitle[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let vc = ListViewController()
        vc.navigationItem.title = listTitle[indexPath.row].category
        let folder = listTitle[indexPath.row]
        let value = folder.content
        vc.list = Array(value)
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { [weak self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self?.viewModel.inputDeleteInfo.value = [self?.listTitle ?? [] : indexPath.row]
            success(true)
        }
        delete.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions:[delete])
    }
}