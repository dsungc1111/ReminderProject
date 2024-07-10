//
//  PriorityViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit
import SnapKit


final class PriorityViewController: BaseViewController {

    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "높음", at: 0, animated: true)
        segment.insertSegment(withTitle: "중간", at: 1, animated: true)
        segment.insertSegment(withTitle: "낮음", at: 2, animated: true)
        return segment
    }()
    private let showPriority = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    var passPriority: PassDateDelegate?
    private let viewModel = PriorityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActions()
        bindData()
    }
    
    // segmentcontrol이 바뀔 때
    func bindData() {
        viewModel.outputPriority.bind { _ in
                self.showPriority.text = self.viewModel.outputPriority.value
        }
    }
    private func addActions() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(completebuttonTapped))
        segmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    @objc func segmentValueChanged(_ sender:UISegmentedControl) {
        viewModel.inputPriority(index: sender.selectedSegmentIndex)
    }
    @objc func completebuttonTapped() {
        if let priority = viewModel.outputPriority.value {
                  passPriority?.passPriorityValue(priority)
              }
        navigationController?.popViewController(animated: true)
    }
    override func configureHierarchy() {
        view.addSubview(segmentControl)
        view.addSubview(showPriority)
    }
    override func configureLayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        showPriority.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
