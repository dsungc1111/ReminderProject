//
//  AddListViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/8/24.
//

import UIKit
import SnapKit
import RealmSwift
import Toast

class AddFolderViewController: BaseViewController {
   
    var passFolder: PassFolderDelegate?
    
    var showToast: (() -> Void)?
    var listTitle: Results<Folder>!
    private enum NavigationBarTitle: String {
        case title = "새로운 목록"
        case cancel = "취소"
        case save = "저장"
    }
    let logoBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.shadowColor = UIColor.systemBlue.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 23
        view.layer.masksToBounds = false
        return view
    }()
    let listLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "list.bullet.circle.fill")
        logo.tintColor = .systemBlue
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    lazy var listName = {
        let text = UITextField()
        text.textAlignment = .center
        text.placeholder = "목록 이름"
        text.layer.cornerRadius = 10
        text.backgroundColor = .systemGray4
        text.addTarget(self, action: #selector(listNameDidchange(_:)), for: .editingChanged)
        return text
    }()
    @objc func listNameDidchange(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationbar()
        listTitle = realm.objects(Folder.self)
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
    @objc func cancelButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    @objc func saveButtonTapped() {
        view.makeToast("저장완료!", duration: 2.0, position: .center)
        guard let listNameText = listName.text else { return }
        let newFolder = Folder(category: listNameText, content: List<RealmTable>())
            
       let realm = try! Realm()
        
        try! realm.write {
            realm.add(newFolder)
        }
        showToast?()
        passFolder?.passFolderList(listTitle)
        navigationController?.dismiss(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(logoBackView)
        view.addSubview(listLogo)
        view.addSubview(listName)
    }
    override func configureLayout() {
        logoBackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(63)
        }
        listLogo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(80)
        }
        listName.snp.makeConstraints { make in
            make.top.equalTo(listLogo.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    
}