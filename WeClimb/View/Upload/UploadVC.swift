//
//  UploadVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import AVKit
import Photos
import UIKit

import SnapKit
import RxCocoa
import RxSwift

enum UploadCellType {
    case caption
    case option
    
    var cellIdentifier: String {
        switch self {
        case .caption:
            return Identifiers.captionCell
        case .option:
            return Identifiers.uploadOptionCell
        }
    }

    var cellClass: UITableViewCell.Type {
        switch self {
        case .caption:
            return CaptionCell.self
        case .option:
            return UploadOptionCell.self
        }
    }
}

class UploadVC: UIViewController {
        
    private lazy var viewModel: UploadVM = {
        return UploadVM()
    }()
    
    private let cellTypes: [UploadCellType] = [.caption, .option, .option]
    
    private let disposeBag = DisposeBag()
    
    private let selectedMediaView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    private let callPHPickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = UIColor(named: "MainColor") // 앱 틴트 컬러
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let uploadOptionTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    private let postButton: UIButton = {
       let button = UIButton()
        button.setTitle("게시", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = UIColor(named: "MainColor") // 앱 틴트 컬러
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "새 게시물"
        setLayout()
        setTableView()
    }
    
    private func setTableView() {
        cellTypes.forEach { cellType in
            uploadOptionTableView.register(cellType.cellClass, forCellReuseIdentifier: cellType.cellIdentifier)
        }
        
        uploadOptionTableView.dataSource = self
        uploadOptionTableView.delegate = self
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
        [selectedMediaView, uploadOptionTableView, postButton]
            .forEach {
                view.addSubview($0)
            }
        selectedMediaView.addSubview(callPHPickerButton)
        
        selectedMediaView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(view.frame.width)
        }
        
        callPHPickerButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 50))
        }
        
        uploadOptionTableView.snp.makeConstraints {
            $0.top.equalTo(selectedMediaView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(postButton.snp.top).offset(-16)
        }
        
        postButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(50)
        }
        
        
        
    }
}

extension UploadVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.cellIdentifier, for: indexPath)
        
        switch cellType {
        case .caption:
            if let captionCell = cell as? CaptionCell {
                
            }
        case .option:
            if let optionCell = cell as? UploadOptionCell {
                if indexPath.row == 1 {
                    
                } else if indexPath.row == 2 {
                    
                }
            }
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cellType = cellTypes[indexPath.row]
//         switch cellType {
//         case .caption:
//             return 200
//         case .option:
//             return 100
//         }
//    }
    
    
}
