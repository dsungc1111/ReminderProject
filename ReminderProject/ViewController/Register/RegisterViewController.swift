//
//  ViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit
import PhotosUI
import RealmSwift
import Toast

final class RegisterViewController: BaseViewController, PassDateDelegate {
    
    var passData: PassDataDelegate?
    private enum Category: String, CaseIterable {
        case dueDate = "마감일"
        case tag = "태그"
        case priority = "우선순위"
        case addImage = "이미지 추가"
    }
    private let tableView = UITableView()
    private let loadedImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private var memoTitleText = ""
    private var memoContentText = ""
    private var getDueDate: Date?
    private var getTagText = ""
    private var getPriority = ""
    var showToast: (() -> Void)?
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
        view.makeToast("저장완료!", duration: 2.0, position: .center)
        let realm = try! Realm()
        let newData = RealmTable(memoTitle: memoTitleText, date: getDueDate, memo: memoContentText, tag: getTagText, priority: getPriority, isFlag: false, complete: false )
        try! realm.write {
            realm.add(newData)
            print("realm create succeed")
        }
        if let image = loadedImageView.image {
            saveImageToDocument(image: image, filename: "\(newData.key)")
        }
        showToast?()
        passData?.passDataList(DataList.list)
        navigationController?.dismiss(animated: true)
    }
    override func tableViewSetting() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.id)
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.id)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    private func configureNavigationbar() {
        navigationItem.title = "새로운 미리 알림"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.backButtonTitle = "취소"
    }
    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(loadedImageView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(180)
        }
        loadedImageView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(70)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(180)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(60)
        }
    }
    func passDateValue(_ date: Date) {
        getDueDate = date
        print(#function)
        tableView.reloadData()
    }
    func passTagValue(_ text: String) {
        getTagText = "# \(text)"
        tableView.reloadData()
    }
    func passPriorityValue(_ text: String) {
        getPriority = text
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
                if let date = getDueDate {
                    cell.resultLabel.text = Date.getDateString(date: date)
                } else {
                    cell.resultLabel.text = ""
                }
            case 1:
                cell.resultLabel.text = getTagText
            case 2:
                cell.resultLabel.text = getPriority
            case 3:
                cell.resultLabel.text = ""
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
                vc.passTag = self
                navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = PriorityViewController()
                vc.passPriority = self
                vc.navigationItem.title = Category.allCases[2].rawValue
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                var config = PHPickerConfiguration()
                config.filter = .any(of: [.images, .livePhotos, .screenshots])
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                present(picker, animated: true)
                
            default:
                break
            }
        }
    }
}
extension RegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function)
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
               
                DispatchQueue.main.async {
                    self.loadedImageView.image = image as? UIImage
                }
            }
            dismiss(animated: true)
        }
    }
    
    
}
