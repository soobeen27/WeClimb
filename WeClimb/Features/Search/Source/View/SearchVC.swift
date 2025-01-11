//
//  SearchVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

enum ItemType {
    case gym
    case user
}

struct Item {
    var type: ItemType
    var name: String
    var imageName: String
    var location: String?
    var height: Double?
}

class SearchVC: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    var coordinator: SearchCoordinator?

    private let disposeBag = DisposeBag()

    private var items = BehaviorRelay<[Item]>(value: [])

    private let dummyItems: [Item] = [
        Item(type: .gym, name: "더 클라임", imageName: "gym_image1", location: "서울시 강남구", height: nil),
        Item(type: .user, name: "홍길동", imageName: "user_image1", location: nil, height: 180.0),
        Item(type: .gym, name: "9클라이밍", imageName: "gym_image2", location: "서울시 마포구", height: nil),
        Item(type: .user, name: "홍길동", imageName: "user_image2", location: nil, height: 175.0)
    ]

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색하기"
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lineOpacityNormal.cgColor
        textField.font = .customFont(style: .body2Medium)
        textField.textColor = .black

        let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
        searchIcon.contentMode = .scaleAspectFit
        let iconWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 24 + 12 + 8, height: 24))
        iconWrapper.addSubview(searchIcon)
        searchIcon.frame.origin = CGPoint(x: 12, y: 1)

        textField.leftView = iconWrapper
        textField.leftViewMode = .always

        return textField
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 방문"
        label.font = UIFont.customFont(style: .label1SemiBold)
        label.textColor = .labelStrong
        label.textAlignment = .left
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(SearchGymTableCell.self, forCellReuseIdentifier: SearchGymTableCell.className)
        tableView.register(SearchUserTableCell.self, forCellReuseIdentifier: SearchUserTableCell.className)
        tableView.rowHeight = 60
        return tableView
    }()

    private let smallCancelButton: UIButton = {
        let button = UIButton(type: .system)
        let closeIcon = UIImage(named: "closeIcon.circle")?.withRenderingMode(.alwaysTemplate)
        button.setImage(closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .labelAssistive
        button.alpha = 0
        button.addTarget(self, action: #selector(didTapSmallCancelButton), for: .touchUpInside)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let closeIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.alpha = 0
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()

    private let rightViewContainer: UIView = {
        let view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setLayout()
        bindTableView()

        items.accept(dummyItems)
        searchTextField.delegate = self

    }

    private func setLayout() {
        [searchTextField, titleLabel, tableView, cancelButton]
            .forEach { view.addSubview($0)}

        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(8)
            $0.height.equalTo(56)
            $0.leading.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.trailing.equalToSuperview().offset(48)
            $0.centerY.equalTo(searchTextField)
        }
    }

    private func bindTableView() {
        items
            .bind(to: tableView.rx.items) { tableView, row, item in
                let cell: UITableViewCell
                if item.type == .gym {
                    let gymCell = tableView.dequeueReusableCell(withIdentifier: SearchGymTableCell.className, for: IndexPath(row: row, section: 0)) as! SearchGymTableCell
                    gymCell.configure(with: item)
                    cell = gymCell
                } else {
                    let userCell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableCell.className, for: IndexPath(row: row, section: 0)) as! SearchUserTableCell
                    userCell.configure(with: item)
                    cell = userCell
                }
                return cell
            }
            .disposed(by: disposeBag)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.fillSolidDarkBlack.cgColor

        UIView.animate(withDuration: 0.3, animations: {
            self.searchTextField.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-48)
            }

            self.cancelButton.alpha = 1
            self.cancelButton.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-16)
            }

            self.view.layoutIfNeeded()
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        rightViewContainer.addSubview(smallCancelButton)


        smallCancelButton.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }

        rightViewContainer.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }

        searchTextField.rightView = rightViewContainer
        searchTextField.rightViewMode = .whileEditing

        if let text = textField.text, !text.isEmpty {
            smallCancelButton.alpha = 1
        } else {
            smallCancelButton.alpha = 0
        }

        return true
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func didTapCancelButton() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        
        searchTextField.layer.borderColor = UIColor.lineOpacityNormal.cgColor

        UIView.animate(withDuration: 0.3) {
            self.searchTextField.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
            }
            
            self.cancelButton.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(16)
            }
            
            self.cancelButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func didTapSmallCancelButton() {
        searchTextField.text = ""
        smallCancelButton.alpha = 0
        searchTextField.rightView = nil
    }
}
