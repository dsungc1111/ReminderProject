//
//  PriorityViewController.swift
//  ReminderProject
//
//  Created by 최대성 on 7/3/24.
//

import UIKit
import SnapKit


class PriorityViewController: BaseViewController {

    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "높음", at: 0, animated: true)
        segment.insertSegment(withTitle: "중간", at: 1, animated: true)
        segment.insertSegment(withTitle: "낮음", at: 2, animated: true)
        return segment
    }()
    var passPriority: PassDateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(completebuttonTapped))
    }
    @objc func completebuttonTapped() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            if let text = segmentControl.titleForSegment(at: 0) {
                passPriority?.passPriorityValue(text)
            }
        case 1:
            if let text = segmentControl.titleForSegment(at: 1) {
                passPriority?.passPriorityValue(text)
            }
        case 2:
            if let text = segmentControl.titleForSegment(at: 2) {
                passPriority?.passPriorityValue(text)
            }
        default:
            break
        }
        
        navigationController?.popViewController(animated: true)
    }
    override func configureHierarchy() {
        view.addSubview(segmentControl)
    }
    override func configureLayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

}
