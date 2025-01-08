//
//  LevelHoldFilterVC.swift
//  WeClimb
//
//  Created by 강유정 on 1/3/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

enum cellType {
    case level
    case hold
}

class LevelHoldFilterVC: UIViewController {
    //    var coordinator: LevelHoldFilterCoordinator?
    
    private let gymUseCase: GymUseCase
    
    private var gym: Gym?
    
    private var gymName: String
    private var grades: [String] = []
    
    private var currentData: BehaviorSubject<[(text: String, image: String, isChecked: Bool)]> = BehaviorSubject(value: [])
    private var currentLevelData: BehaviorSubject<[(text: String, image: String, isChecked: Bool)]> = BehaviorSubject(value: [])
    private var currentHoldData: BehaviorSubject<[(text: String, image: String, isChecked: Bool)]> = BehaviorSubject(value: [])
    
    private var selectedLevel: String?
    private var selectedHold: String?
    
    let appliedFiltersSubject = PublishSubject<(levels: [String], holds: [String])>()
    
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 45
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "필터"
        label.font = UIFont.customFont(style: .heading2SemiBold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 236/255, alpha: 1)
        return view
    }()
    
    let segmentedControl = CustomSegmentedControl(items: ["레벨", "홀드"])
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 236/255, alpha: 1)
        return view
    }()
    
    private let buttonLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 236/255, alpha: 1)
        return view
    }()
    
    private let applyButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle("적용", for: .normal)
        return button
    }()
    
    init(gymName: String, gymUseCase: GymUseCase) {
        self.gymName = gymName
        self.gymUseCase = gymUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        adjustModalHeight()
        bindSegmentedControl()
        bindTableView()
        bindSelectCell()
        
        fetchGymData()
        
        bindapplyButton()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [titleLabel, topLineView, segmentedControl, bottomLineView, tableView, buttonLineView, applyButton].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        topLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(topLineView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(-1)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(bottomLineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonLineView.snp.top)
        }
        
        buttonLineView.snp.makeConstraints {
            $0.bottom.equalTo(applyButton.snp.top).offset(-16)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        applyButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.register(LevelHoldFilterTableCell.self, forCellReuseIdentifier: LevelHoldFilterTableCell.className)
    }
}

extension LevelHoldFilterVC {
    private func fetchGymData() {
        gymUseCase.gymInfo(gymName: gymName)
            .subscribe(onSuccess: { [weak self] gym in
                guard let self = self else { return }
                self.gym = gym
                self.updateTableViewForLevels()
            }, onFailure: { error in
                print("데이터를 가져오는 중 오류: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        currentData
            .bind(to: tableView.rx.items(cellIdentifier: LevelHoldFilterTableCell.className, cellType: LevelHoldFilterTableCell.self)) { index, item, cell in
                guard let currentItems = try? self.currentData.value() else {
                    return
                }
                
                let isFirstCell = index == 0
                let isLastCell = index == currentItems.count - 1
                
                cell.configure(with: item.text, imageName: item.image, isChecked: item.isChecked, isFirstCell: isFirstCell, isLastCell: isLastCell)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSelectCell() {
        tableView.rx.modelSelected((text: String, image: String, isChecked: Bool).self)
            .bind(onNext: { [weak self] selectedItem in
                guard let self = self else { return }
                
                var currentItems: [(text: String, image: String, isChecked: Bool)] = []
                
                if self.segmentedControl.selectedSegmentIndex == 0 {
                    currentItems = try! self.currentLevelData.value()
                } else if self.segmentedControl.selectedSegmentIndex == 1 {
                    currentItems = try! self.currentHoldData.value()
                }
                
                if let index = currentItems.firstIndex(where: { $0.text == selectedItem.text }) {
                    currentItems[index].isChecked.toggle()
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                self.currentData.onNext(currentItems)
                
                if self.segmentedControl.selectedSegmentIndex == 0 {
                    self.currentLevelData.onNext(currentItems)
                    self.selectedLevel = selectedItem.text
                } else if self.segmentedControl.selectedSegmentIndex == 1 {
                    self.currentHoldData.onNext(currentItems)
                    self.selectedHold = selectedItem.text
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSegmentedControl() {
        segmentedControl.onSegmentChanged = { [weak self] selectedIndex in
            guard let self = self else { return }
            
            if selectedIndex == 0 {
                currentData.onNext(try! self.currentLevelData.value())
                self.updateTableViewForLevels()
            } else if selectedIndex == 1 {
                currentData.onNext(try! self.currentHoldData.value())
                self.updateTableViewForHolds()
            }
        }
    }
    
    private func updateTableViewForLevels() {
        guard let gym = gym else { return }
        
        let levelData = gym.grade.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        
        let levelTextImageData: [(text: String, image: String, isChecked: Bool)] = levelData.map { level in
            return (text: level.colorTextChange(), image: level.imageTextChange(), isChecked: false)
        }
        
        currentLevelData.onNext(levelTextImageData)
        currentData.onNext(levelTextImageData)
    }
    
    private func updateTableViewForHolds() {
        let holdTextImageData: [(text: String, image: String, isChecked: Bool)] = Hold.allCases.map { holdEnum in
            return (text: holdEnum.koreanHold, image: holdEnum.imageName, isChecked: false)
        }
        
        currentHoldData.onNext(holdTextImageData)
        currentData.onNext(holdTextImageData)
    }
}

extension LevelHoldFilterVC {
    private func bindapplyButton() {
        applyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.applyFilters()
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func applyFilters() {
        print("선택된 레벨: \(String(describing: selectedLevel)), 선택된 홀드: \(String(describing: selectedHold))")
        
        let levels = selectedLevel.map { [$0] } ?? []
        let holds = selectedHold.map { [$0] } ?? []
        
        appliedFiltersSubject.onNext((levels: levels, holds: holds))
    }
}

extension LevelHoldFilterVC {
    private func adjustModalHeight() {
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return 710
                }
            ]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
    }
}






















//enum CellType {
//    case level
//    case hold
//}
//
//class LevelHoldFilterVC: UIViewController {
//    
//    var coordinator: LevelHoldFilterCoordinator?
//    private let gymRepository: GymRepository
//    private var gym: Gym?
//    
//    private let gymName: String
//    private var selectedLevel: String?
//    private var selectedHold: String?
//    
//    let appliedFiltersSubject = PublishSubject<(levels: [String], holds: [String])>()
//    private let disposeBag = DisposeBag()
//    
//    private let tableView = UITableView()
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "필터"
//        label.font = UIFont.customFont(style: .heading2SemiBold)
//        label.textColor = .black
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private let segmentedControl = CustomSegmentedControl(items: ["레벨", "홀드"])
//    private let applyButton: WeClimbButton = {
//        let button = WeClimbButton(style: .defaultRectangle)
//        button.setTitle("적용", for: .normal)
//        return button
//    }()
//    
//    private var currentLevelData = BehaviorSubject<[(text: String, image: String, isChecked: Bool)]>(value: [])
//    private var currentHoldData = BehaviorSubject<[(text: String, image: String, isChecked: Bool)]>(value: [])
//    private var currentData = BehaviorSubject<[(text: String, image: String, isChecked: Bool)]>(value: [])
//    
//    init(gymName: String, gymRepository: GymRepository) {
//        self.gymName = gymName
//        self.gymRepository = gymRepository
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        adjustModalHeight()
//        bindUIElements()
//        fetchGymData()
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        [titleLabel, segmentedControl, tableView, applyButton].forEach { view.addSubview($0) }
//        
//        titleLabel.snp.makeConstraints { $0.top.equalTo(view.safeAreaLayoutGuide).inset(15); $0.centerX.equalToSuperview(); $0.height.equalTo(48) }
//        segmentedControl.snp.makeConstraints { $0.top.equalTo(titleLabel.snp.bottom); $0.leading.trailing.equalToSuperview().inset(16); $0.height.equalTo(48) }
//        tableView.snp.makeConstraints { $0.top.equalTo(segmentedControl.snp.bottom); $0.leading.trailing.bottom.equalToSuperview(); }
//        applyButton.snp.makeConstraints { $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16); $0.leading.trailing.equalToSuperview().inset(16) }
//        
//        tableView.separatorStyle = .none
//        tableView.rowHeight = 45
//        tableView.register(LevelHoldFilterTableCell.self, forCellReuseIdentifier: LevelHoldFilterTableCell.className)
//    }
//    
//    private func bindUIElements() {
//        bindSegmentedControl()
//        bindTableView()
//        bindApplyButton()
//        bindCheck()
//    }
//    
//    private func bindSegmentedControl() {
//        segmentedControl.onSegmentChanged = { [weak self] selectedIndex in
//            guard let self = self else { return }
//            self.updateData(for: selectedIndex == 0 ? .level : .hold)
//        }
//    }
//    
//    private func bindTableView() {
//        currentData
//            .bind(to: tableView.rx.items(cellIdentifier: LevelHoldFilterTableCell.className, cellType: LevelHoldFilterTableCell.self)) { index, item, cell in
//                let isFirstCell = index == 0
//                let isLastCell = index == (try! self.currentData.value().count) - 1
//                cell.configure(with: item.text, imageName: item.image, isChecked: item.isChecked, isFirstCell: isFirstCell, isLastCell: isLastCell)
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    private func bindCheck() {
//        tableView.rx.modelSelected((text: String, image: String, isChecked: Bool).self)
//            .subscribe(onNext: { [weak self] selectedItem in
//                guard let self = self else { return }
//                self.toggleCheck(for: selectedItem)
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    private func bindApplyButton() {
//        applyButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.applyFilters()
//                self?.dismiss(animated: true)
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    private func fetchGymData() {
//        gymRepository.gymInfo(gymName: gymName)
//            .subscribe(onSuccess: { [weak self] gym in
//                self?.gym = gym
//                self?.updateData(for: .level)
//            }, onFailure: { error in
//                print("데이터를 가져오는 중 오류: \(error)")
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    private func updateData(for type: CellType) {
//        switch type {
//        case .level:
//            currentData.onNext(try! self.currentLevelData.value())
//            updateTableViewForLevels()
//        case .hold:
//            currentData.onNext(try! self.currentHoldData.value())
//            updateTableViewForHolds()
//        }
//    }
//
//    private func updateTableViewForLevels() {
//        guard let gym = gym else { return }
//        let levelData = gym.grade.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
//        
//        let levelTextImageData = levelData.map { (text: $0.colorTextChange(), image: $0.imageTextChange(), isChecked: $0 == selectedLevel) }
//        
//        currentLevelData.onNext(levelTextImageData)
//    }
//    
//    private func updateTableViewForHolds() {
//        let holdTextImageData = Hold.allCases.map { (text: $0.koreanHold, image: $0.imageName, isChecked: $0.koreanHold == selectedHold) }
//        
//        currentHoldData.onNext(holdTextImageData)
//    }
//    
//    private func toggleCheck(for selectedItem: (text: String, image: String, isChecked: Bool)) {
//        guard var currentItems = try? currentData.value() else { return }
//        
//        currentItems = currentItems.map { item in
//            var newItem = item
//            newItem.isChecked = item.text == selectedItem.text ? !newItem.isChecked : item.isChecked
//            return newItem
//        }
//        
//        currentData.onNext(currentItems)
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            selectedLevel = selectedItem.isChecked ? selectedItem.text : nil
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            selectedHold = selectedItem.isChecked ? selectedItem.text : nil
//        }
//    }
//    
//    private func applyFilters() {
//        print("선택된 레벨: \(String(describing: selectedLevel)), 선택된 홀드: \(String(describing: selectedHold))")
//        appliedFiltersSubject.onNext(
//            (levels: selectedLevel != nil ? [selectedLevel!] : [], holds: selectedHold != nil ? [selectedHold!] : [])
//        )
//    }
//    
//    private func adjustModalHeight() {
//        if let sheet = sheetPresentationController {
//            sheet.detents = [
//                .custom { context in
//                    return 710
//                }
//            ]
//            sheet.preferredCornerRadius = 20
//            sheet.prefersGrabberVisible = true
//        }
//    }
//}
