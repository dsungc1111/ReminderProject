//
//  ViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/2/24.
//

import UIKit
import SnapKit
import PhotosUI
import Toast

final class AddToDoViewController: BaseViewController {
 
    var passData: PassDataDelegate?
    private enum Category: String, CaseIterable {
        case dueDate = "마감일"
        case tag = "태그"
        case priority = "우선순위"
        case addImage = "이미지 추가"
        case list = "목록"
    }
    private enum NavigationBarTitle: String {
        case title = "새로운 미리 알림"
        case cancel = "취소"
        case save = "저장"
    }
    private let viewModel = AddToDoViewModel()
    private let repository = RealmTableRepository()
    private lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.id)
        view.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.id)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private let loadedImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private var listTitle: [Folder] = []
    private var toDolist: [RealmTable] = []
    private var memoTitleText = ""
    private var memoContentText = ""
    
    var showToast: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationbar()
        bindData()
        
    }
    func bindData() {
        viewModel.outputData.bind { _ in
            self.tableView.reloadData()
        }
    }
    @objc func cancelButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    @objc func saveButtonTapped() {
        view.makeToast("저장완료!", duration: 2.0, position: .center)
        
        let newData = RealmTable(memoTitle: memoTitleText, date: viewModel.getDueDate, memo: memoContentText, tag: viewModel.getTagText, priority: viewModel.getPriority, isFlag: false, complete: false )
        
        viewModel.saveData(data: newData)
        if let image = loadedImageView.image {
            saveImageToDocument(image: image, filename: "\(newData.key)")
        }
        showToast?()
        passData?.passDataList(toDolist)
        navigationController?.dismiss(animated: true)
    }
    private func configureNavigationbar() {
        navigationItem.title = NavigationBarTitle.title.rawValue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NavigationBarTitle.cancel.rawValue, style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavigationBarTitle.save.rawValue, style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.backButtonTitle = NavigationBarTitle.cancel.rawValue
    }
    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(loadedImageView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        loadedImageView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(70)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(180)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(60)
        }
    }
}
extension AddToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return Category.allCases.count
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
                if let date = viewModel.getDueDate {
                    cell.resultLabel.text = Date.getDateString(date: date)
                } else {
                    cell.resultLabel.text = ""
                }
            case 1:
                cell.resultLabel.text = viewModel.getTagText
            case 2:
                cell.resultLabel.text = viewModel.getPriority
            case 3:
                cell.resultLabel.text = ""
            case 4:
                cell.resultLabel.text = viewModel.getFolder
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
                vc.viewModel.passDate = self.viewModel
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = TagViewController()
                vc.navigationItem.title = Category.allCases[1].rawValue
                vc.passTag = viewModel
                navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = PriorityViewController()
                vc.passPriority = viewModel
                vc.navigationItem.title = Category.allCases[2].rawValue
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                var config = PHPickerConfiguration()
                config.filter = .any(of: [.images, .livePhotos, .screenshots])
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                present(picker, animated: true)
            case 4:
                let vc = FolderListViewController()
                vc.passFolder = viewModel
                vc.navigationItem.title = Category.allCases[4].rawValue
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
}
extension AddToDoViewController: PHPickerViewControllerDelegate {
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
