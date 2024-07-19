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
    deinit {
        print("addtodo VC deinit")
    }
    private enum NavigationBarTitle: String {
        case title = "새로운 미리 알림"
        case cancel = "취소"
        case save = "저장"
    }
    
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
    
    var showToast: (() -> Void)?
    
    let viewModel = AddToDoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func bindData() {
        viewModel.outputMemoTitle.bindLater { [weak self] _ in
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
            self?.navigationItem.rightBarButtonItem?.tintColor = .black
        }
        viewModel.getData.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.outputDataList.bind { [weak self] _ in
            if let image = self?.loadedImageView.image,
               let filename = self?.viewModel.outputDataList.value?.key {
                self?.saveImageToDocument(image: image, filename: "\(filename)")
            }
        }
    }
    override func configureNavigationbar() {
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
    
    @objc func saveButtonTapped() {
        view.makeToast("저장완료!", duration: 2.0, position: .center)
        viewModel.inputSaveButton.value = ()
        showToast?()
        navigationController?.dismiss(animated: true)
    }
    @objc func cancelButtonTapped() {
        navigationController?.dismiss(animated: true)
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
            return viewModel.outputSelectCategory.value.count
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
            if indexPath.row == 0 {
                cell.resultLabel.text = Date.getDateString(date: viewModel.inputDueDate.value)
            } else {
                cell.resultLabel.text = viewModel.getDataList.value[indexPath.row-1]
            }
            cell.titleLabel.text = viewModel.outputSelectCategory.value[indexPath.row]
            return cell
        }
    }
    @objc func titleFieldChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        viewModel.inputMemoTitle.value = text
    }
    @objc func memoFieldChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        viewModel.inputMemoContent.value = text
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 200 }
        else { return 80 }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let list = viewModel.outputSelectCategory.value
        if indexPath.section != 0 {
            switch indexPath.row {
            case 0:
                let vc = DateViewController()
                vc.navigationItem.title = list[0]
                vc.viewModel.passDate = self.viewModel
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = TagViewController()
                vc.navigationItem.title = list[1]
                vc.viewModel.passTag = self.viewModel
                navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = PriorityViewController()
                vc.viewModel.passPriority = self.viewModel
                vc.navigationItem.title = list[2]
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                var config = PHPickerConfiguration()
                config.filter = .any(of: [.images, .livePhotos, .screenshots])
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                present(picker, animated: true)
            case 4:
                let vc = FolderListViewController()
                vc.viewModel.passFolder = self.viewModel
                vc.navigationItem.title = list[4]
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
}
extension AddToDoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.loadedImageView.image = image as? UIImage
                }
            }
        }
        dismiss(animated: true)
    }
}
