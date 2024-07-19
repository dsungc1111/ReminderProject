//
//  CalendarViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/8/24.
//

import UIKit
import FSCalendar
import SnapKit

final class CalendarViewController: BaseViewController {
  
    private var chooseMonthOrWeek = true
    
    private let viewModel = CalendarViewModel()
    
    private lazy var calendarView = { 
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.swipeToChooseGesture.isEnabled = true
        return calendar
    }()
    
    private lazy var searchTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func bindData() {
        viewModel.monthOrWeek.bind { [weak self] _ in
            if let calendar = self?.viewModel.monthOrWeek.value {
                self?.calendarView.scope = calendar ? .month : .week
            }
        }
        viewModel.outputSelecteDateList.bind { [weak self] _ in
            self?.searchTableView.reloadData()
        }
    }
    override func configureHierarchy() {
        view.addSubview(calendarView)
        view.addSubview(searchTableView)
    }
    override func configureLayout() {
        calendarView.snp.updateConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(viewModel.monthOrWeek.value ?? false ?  300 : 120)
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func addActions() {
        let date = Date()
        calendarView.select(date)
        calendarView.delegate?.calendar?(calendarView, didSelect: date, at: .current)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panGestureHandler(gesture: UIPanGestureRecognizer) {
        
     if gesture.state == .ended {
            viewModel.monthOrWeek.value?.toggle()
            configureLayout()
        }
    }
 
}
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.inputDate.value = date
    }
}
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputSelecteDateList.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return ListTableViewCell() }
        let data = viewModel.outputSelecteDateList.value?[indexPath.row]
        cell.completeButton.tag = indexPath.row
        let image = data?.isComplete ?? false ? "circle.fill" : "circle"
        cell.completeButton.setImage(UIImage(systemName: image), for: .normal)
        cell.configureCell(data: data ?? RealmTable())
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}