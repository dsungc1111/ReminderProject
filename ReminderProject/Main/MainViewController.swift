//
//  MainViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift
import IQKeyboardManagerSwift
import Toast

final class MainViewController: BaseViewController {
   
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (sectionSpacing*2 + cellSpacing*2)
        layout.itemSize = CGSize(width: width/2, height: width/4)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    private lazy var addButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.setTitle(" 새로운 일 추가", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var listAddButton = {
        let btn = UIButton()
        btn.setTitle("목록추가", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(listAddButtonTapped), for: .touchUpInside)
        return btn
    }()
    @objc func listAddButtonTapped() {
        let vc = AddListViewController()
        vc.showToast = {
            self.view.makeToast("저장완료!")
        }
        vc.passFolder = self
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.present(nav, animated: true)
    }
    let myListLabel = {
        let label = UILabel()
        label.text = "나의 목록"
        label.font = .boldSystemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()
    private let realm = try! Realm()
    private let date = Date()
    private let repository = RealmTableRepository()
    var listTitle: Results<Folder>!
    private let containerView = UIView()
    private lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(AddFolderTableViewCell.self, forCellReuseIdentifier: AddFolderTableViewCell.id)
        view.layer.cornerRadius = 10
        view.showsVerticalScrollIndicator = false
        view.estimatedRowHeight = 50
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        listTitle = realm.objects(Folder.self)
        navigationbarSetting()
        collectionViewSetting()
        myListLabel.isHidden = listTitle.count != 0 ? false : true
        DataList.list = realm.objects(RealmTable.self)
        listTitle = realm.objects(Folder.self)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .always
        collectionView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.layer.addBorder([.bottom], color: .systemGray4, width: 1)
    }
    private func collectionViewSetting() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
    }
    private func navigationbarSetting() {
        navigationItem.title = "대성's 미리알림"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
    }
    @objc func searchButtonTapped() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func calendarButtonTapped() {
        let vc = CalendarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addButtonTapped() {
        let vc = RegisterViewController()
        vc.showToast = {
            self.view.makeToast("저장완료!")
        }
        vc.passData = self
        let nav = UINavigationController(rootViewController: vc)
        navigationController?.present(nav, animated: true)
    }
    override func configureHierarchy() {
        view.addSubview(addButton)
        view.addSubview(listAddButton)
        view.addSubview(collectionView)
        view.addSubview(myListLabel)
        view.addSubview(containerView)
        view.addSubview(tableView)
    }
    override func configureLayout() {
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        listAddButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(320)
        }
        myListLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(myListLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(listAddButton.snp.top)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).inset(10)
            make.horizontalEdges.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(5)
        }
    }
}
extension MainViewController:  PassDataDelegate, PassFolderDelegate {
    func passFolderList(_ dataList: RealmSwift.Results<Folder>) {
        listTitle = dataList
        tableView.reloadData()
    }
    func passDataList(_ dataList: RealmSwift.Results<RealmTable>) {
        DataList.list = dataList
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
        switch indexPath.row {
        case 0:
            vc.navigationItem.title = ContentNameEnum.today.rawValue
            vc.list = repository.fetchCategory(cases: 0)
        case 1:
            vc.navigationItem.title = ContentNameEnum.plan.rawValue
            vc.list = repository.fetchCategory(cases: 1)
        case 2:
            vc.navigationItem.title = ContentNameEnum.all.rawValue
            vc.list = repository.fetchCategory(cases: 2)
        case 3:
            vc.navigationItem.title = ContentNameEnum.flag.rawValue
            vc.list = repository.fetchCategory(cases: 3)
        case 4:
            vc.navigationItem.title = ContentNameEnum.complete.rawValue
            vc.list = repository.fetchCategory(cases: 4)
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddFolderTableViewCell.id, for: indexPath) as? AddFolderTableViewCell else { return AddFolderTableViewCell() }
        let data = listTitle[indexPath.row]
        cell.contentName.text = data.category
        cell.numberOfContentsLabel.text = "\(data.content.count)" + "개"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
}
