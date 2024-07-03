//
//  ViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class RegisterViewController: BaseViewController, PassDateDelegate {
    
    private enum Category: String, CaseIterable {
        case dueDate = "마감일"
        case tag = "태그"
        case priority = "우선순위"
        case addImage = "이미지 추가"
    }
    
    private let tableView = UITableView()
    private var memoTitleText = ""
    private var memoContentText = ""
    private var getDueDate = ""
    
    private let realm = try! Realm()
    private var list: Results<RealmTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationbar()
        list = realm.objects(RealmTable.self).sorted(byKeyPath: MemoContents.memoTitle.rawValue , ascending: true)
    }

    @objc func cancelButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    @objc func saveButtonTapped() {
        let realm = try! Realm()
        let newData = RealmTable(memoTitle: memoTitleText, date: getDueDate, memo: memoContentText)
        try! realm.write {
            realm.add(newData)
            print("realm create succeed")
        }
        navigationController?.dismiss(animated: true)
    }
    override func tableViewSetting() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.id)
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.id)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
    }
    private func configureNavigationbar() {
        navigationItem.title = "새로운 미리 알림"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func passDateValue(_ text: String) {
        getDueDate = text
        tableView.reloadData()
    }
}
extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.id, for: indexPath) as? TodoTableViewCell else { return TodoTableViewCell() }
            cell.titleTextField.addTarget(self, action: #selector(titleFieldChange(_:)), for: .editingChanged)
            cell.memoTextField.addTarget(self, action: #selector(memoFieldChange(_:)), for: .editingChanged)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.id, for: indexPath) as? CategoryTableViewCell else { return CategoryTableViewCell() }
            
            switch indexPath.row {
            case 0:
                cell.resultLabel.text = getDueDate
            default:
                break
            }
            
            
            cell.titleLabel.text = Category.allCases[indexPath.row].rawValue
            return cell
        }
    }
   
    @objc func titleFieldChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        memoTitleText = text
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    @objc func memoFieldChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        memoContentText = text
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        else {
            return 80
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        if indexPath.section != 0 {
            switch indexPath.row {
            case 0:
                let vc = DateViewController()
                vc.navigationItem.title = Category.allCases[0].rawValue
                vc.passDate = self
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = TagViewController()
                vc.navigationItem.title = Category.allCases[1].rawValue
                navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = PriorityViewController()
                vc.navigationItem.title = Category.allCases[2].rawValue
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = ImageAddViewController()
                vc.navigationItem.title = Category.allCases[3].rawValue
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            
            
           
            
           
        }
    }
}


