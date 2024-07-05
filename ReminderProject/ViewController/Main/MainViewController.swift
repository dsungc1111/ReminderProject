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
import FSCalendar
import Toast

final class MainViewController: BaseViewController {
    
    
    private lazy var searchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "검색"
        search.backgroundColor = .clear
        search.barTintColor = .systemGray6
        search.searchTextField.backgroundColor = .white
        return search
    }()
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
        btn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return btn
    }()
    private var isCalendar = false
    private lazy var backView = {
       let view = UIView()
        view.backgroundColor = .systemGray6
        view.isHidden = true
        return view
    }()
    var isMonth = true
    private lazy var calendarView = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.isHidden = true
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.swipeToChooseGesture.isEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        calendar.addGestureRecognizer(panGestureRecognizer)
        return calendar
    }()
    @objc func panGestureHandler() {
        isMonth.toggle()
        calendarView.scope = isMonth ? .month : .week
    }
    private lazy var searchTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        return tableView
    }()
    private let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationbarSetting()
        collectionViewSetting()
        DataList.list = realm.objects(RealmTable.self).filter("isComplete == false")
        navigationbarSetting()
//        print(realm.configuration.fileURL)
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    func collectionViewSetting() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
    }
    private func navigationbarSetting() {
        navigationItem.title = "대성's 미리알림"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonTapped))
    }
    @objc func calendarButtonTapped() {
        isCalendar.toggle()
        backView.isHidden = isCalendar ? false : true
        calendarView.isHidden = isCalendar ? false : true
        searchTableView.isHidden = isCalendar ? false : true
        let date = Date()
        calendarView.select(date)
        calendarView.delegate?.calendar?(calendarView, didSelect: date, at: .current)
    }
    @objc func addButtonTapped() {
        let vc = RegisterViewController()
        vc.showToast = {
            vc.view.makeToast("저장완료!")
        }
        let nav = UINavigationController(rootViewController: RegisterViewController())
        navigationController?.present(nav, animated: true)
    }
    override func configureHierarchy() {
        view.addSubview(addButton)
        view.addSubview(listAddButton)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(backView)
        view.addSubview(calendarView)
        view.addSubview(searchTableView)
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
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
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(320)
        }
        backView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        calendarView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(backView)
            make.height.equalTo(320)
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(backView)
        }
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as? MainCollectionViewCell else { return MainCollectionViewCell() }
        cell.configureCell(data: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ListViewController()
        switch indexPath.row {
        case 0:
            DataList.list = realm.objects(RealmTable.self).filter("date BETWEEN {%@, %@} && isComplete == false", Calendar.current.startOfDay(for: Date()), Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: Date())))
            vc.navigationItem.title = ContentNameEnum.today.rawValue
        case 1:
            DataList.list = realm.objects(RealmTable.self).filter("date > %@ && isComplete == false", Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: Date())))
            vc.navigationItem.title = ContentNameEnum.plan.rawValue
        case 2:
            DataList.list = realm.objects(RealmTable.self).sorted(byKeyPath: MemoContents.memoTitle.rawValue , ascending: true)
            DataList.list = realm.objects(RealmTable.self).filter("isComplete == false")
            vc.navigationItem.title = ContentNameEnum.all.rawValue
        case 3:
            DataList.list = realm.objects(RealmTable.self).filter("isFlag == true")
            vc.navigationItem.title = ContentNameEnum.flag.rawValue
        case 4:
            vc.navigationItem.title = ContentNameEnum.complete.rawValue
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        DataList.list = realm.objects(RealmTable.self).filter("date BETWEEN {%@, %@} && isComplete == false", Calendar.current.startOfDay(for: date), Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: date)))
        searchTableView.reloadData()
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        DataList.list = realm.objects(RealmTable.self).filter("date BETWEEN {%@, %@} && isComplete == true", Calendar.current.startOfDay(for: date), Date(timeInterval: 86399, since: Calendar.current.startOfDay(for: date)))
        searchTableView.reloadData()
    }
    
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
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
            self.searchTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = realm.objects(RealmTable.self).where {
            $0.memoTitle.contains(searchText, options: .caseInsensitive)
        }
        let result = searchText.isEmpty ? realm.objects(RealmTable.self) : filter
        DataList.list = result
//        print(DataList.list)
//        tableView.reloadData()
    }
    
}
