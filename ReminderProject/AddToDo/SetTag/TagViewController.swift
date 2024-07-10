//
//  TagViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit
import SnapKit

final class TagViewController: BaseViewController {

    private let tagTextField = {
        let tag = UITextField()
        tag.backgroundColor = .white
        tag.placeholder = "새로운 태그 추가..."
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tag.frame.height))
        tag.leftView = leftPadding
        tag.leftViewMode = UITextField.ViewMode.always
        tag.layer.cornerRadius = 10
        tag.clearButtonMode = .whileEditing
        return tag
    }()
    var passTag: PassDateDelegate?
    let viewModel = TagViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(completebuttonTapped))
        bindData()
    }
    func bindData() {
        viewModel.inputButton.bind { _ in
            if let tagText = self.tagTextField.text {
                self.passTag?.passTagValue(tagText)
            }
        }
    }
    
    @objc func completebuttonTapped() {
      
        viewModel.inputButton.value = ()
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func configureHierarchy() {
        view.addSubview(tagTextField)
    }
    override func configureLayout() {
        tagTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}