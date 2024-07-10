//
//  CalendarViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/8/24.
//

import UIKit
import FSCalendar
import RealmSwift
import SnapKit

final class CalendarViewController: BaseViewController {
    
    private var chooseMonthOrWeek = true
    private let realm = try! Realm()
    let viewModel = CalendarViewModel()
    
    private lazy var calendarView = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.swipeToChooseGesture.isEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        calendar.addGestureRecognizer(panGestureRecognizer)
        return calendar
    }()
    
    private lazy var searchTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        tableView.backgroundColor = .clear
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        DataList.list = realm.objects(RealmTable.self)
        let date = Date()
        calendarView.select(date)
        calendarView.delegate?.calendar?(calendarView, didSelect: date, at: .current)
        bindData()
    }
    func bindData() {
        viewModel.inputMonthOrWeek.bind { _ in
            if let calendar = self.viewModel.inputMonthOrWeek.value {
                self.calendarView.scope = calendar ? .month : .week
            }
        }
        viewModel.outputSelecteDate.bind { _ in
            self.searchTableView.reloadData()
        }
    }
    @objc func panGestureHandler() {
        viewModel.inputMonthOrWeek.value?.toggle()
//        chooseMonthOrWeek.toggle()
//        calendarView.scope = chooseMonthOrWeek ? .month : .week
    }
    override func configureHierarchy() {
        view.addSubview(calendarView)
        view.addSubview(searchTableView)
    }
    override func configureLayout() {
        calendarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
         viewModel.selectDate(date: date)
    }

}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
}