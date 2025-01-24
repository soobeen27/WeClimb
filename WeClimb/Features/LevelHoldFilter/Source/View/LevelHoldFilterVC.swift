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

/// 클래스 생성후
/// levelHoldFilterVC.setFilterViewTheme(theme: .dark) 이런식으로 테마를 설정할 수 있습니다.
class LevelHoldFilterVC: UIViewController {
    private let viewModel: LevelHoldFilterVMImpl
    private let disposeBag = DisposeBag()
    
    private var themeType: FilterViewTheme = .light {
        didSet {
            setTheme()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = LevelHoldFilterConst.Size.cellHeight
        tableView.register(LevelHoldFilterTableCell.self, forCellReuseIdentifier: LevelHoldFilterTableCell.className)
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LevelHoldFilterConst.Text.segmentFilterTiltle
        label.font = UIFont.customFont(style: .heading2SemiBold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LevelHoldFilterConst.Color.lightLineColor
        return view
    }()
    
    let segmentedControl = CustomSegmentedControl(items: [LevelHoldFilterConst.Text.segmentLevelTiltle, LevelHoldFilterConst.Text.segmentHoldTiltle])
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LevelHoldFilterConst.Color.lightLineColor
        return view
    }()
    
    private let buttonLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LevelHoldFilterConst.Color.lightLineColor
        return view
    }()
    
    private let applyButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle(LevelHoldFilterConst.Text.applyButtonTitle, for: .normal)
        return button
    }()
    
    private let selectedSegmentIndexSubject = PublishSubject<Int>()
    private var gymName: String
    private let cellCountSubject = BehaviorSubject<Int>(value: LevelHoldFilterConst.CellState.initialCellCount)
    
    init(gymName: String, viewModel: LevelHoldFilterVMImpl) {
        self.viewModel = viewModel
        self.gymName = gymName
        super.init(nibName: nil, bundle: nil)
       
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bindUI(gymName: gymName)
        adjustModalHeight()
    }
    
    private func bindUI(gymName: String) {
        segmentedControl.onSegmentChanged = { [weak self] selectedIndex in
            self?.selectedSegmentIndexSubject.onNext(selectedIndex)
        }
        
        let input = LevelHoldFilterVMImpl.Input(
            gymName: gymName,
            segmentedControlSelection: selectedSegmentIndexSubject.asObservable(),
            cellSelection: tableView.rx.modelSelected((text: String, image: String, isChecked: Bool).self).asObservable(),
            applyButtonTap: applyButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)

        output.cellData
            .do(onNext: { [weak self] data in
                let totalCount = data.count
                self?.cellCountSubject.onNext(totalCount)
            })
            .bind(to: tableView.rx.items(cellIdentifier: LevelHoldFilterTableCell.className, cellType: LevelHoldFilterTableCell.self)) { [weak self] index, item, cell in

                guard let totalCount = try? self?.cellCountSubject.value() else { return }

                let isFirstCell = index == LevelHoldFilterConst.CellState.firstIndex
                let isLastCell = index == (totalCount - LevelHoldFilterConst.CellState.lastIndexOffset)

                let config = LevelHoldFilterCellConfig(
                    text: item.text,
                    imageName: item.image,
                    isChecked: item.isChecked,
                    isFirstCell: isFirstCell,
                    isLastCell: isLastCell
                )
                
                cell.configure(with: config, theme: self?.themeType ?? .light)
            }
            .disposed(by: disposeBag)
        
        output.selectedItems
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selectedItems in
                guard let self = self else { return }
                
                let selectedIndexes = selectedItems
                
                let indexPaths = selectedIndexes.map { IndexPath(row: $0, section: LevelHoldFilterConst.CellState.tableViewSection) }

                self.tableView.reloadRows(at: indexPaths, with: .automatic)
            })
            .disposed(by: disposeBag)
        
        
        output.appliedFilters
            .subscribe(onNext: { filters in
                print("선택된 필터: \(filters)")
            })
            .disposed(by: disposeBag)
    }
}

extension LevelHoldFilterVC {
    
    enum FilterViewTheme {
        case light
        case dark
    }

    private func setTheme() {
        switch themeType {
        case .light:
            view.backgroundColor = LevelHoldFilterConst.Color.lightBackgroundColor
            titleLabel.textColor = LevelHoldFilterConst.Color.lightTextColor
            applyButton.setTitleColor(LevelHoldFilterConst.Color.lightApplyButtonTitleColor, for: .normal)
            applyButton.backgroundColor = LevelHoldFilterConst.Color.lightApplyButtonBackgroundColor
            
            updateCellTheme(for: .light)
            
            topLineView.backgroundColor = LevelHoldFilterConst.Color.lightLineColor
            bottomLineView.backgroundColor = LevelHoldFilterConst.Color.lightLineColor
            buttonLineView.backgroundColor = LevelHoldFilterConst.Color.lightLineColor
            
            segmentedControl.normalFontColor = LevelHoldFilterConst.Color.SegmentNormalFontColor
            segmentedControl.selectedFontColor = LevelHoldFilterConst.Color.lightSegmentSelectedFontColor
            segmentedControl.indicatorColor = LevelHoldFilterConst.Color.lightSegmentIndicatorColor
            
        case .dark:
            view.backgroundColor = LevelHoldFilterConst.Color.darkBackgroundColor
            tableView.backgroundColor = LevelHoldFilterConst.Color.darkBackgroundColor
            titleLabel.textColor = LevelHoldFilterConst.Color.darkTextColor
            applyButton.setTitleColor(LevelHoldFilterConst.Color.darkApplyButtonTitleColor, for: .normal)
            applyButton.backgroundColor = LevelHoldFilterConst.Color.darkApplyButtonBackgroundColor
            
            topLineView.backgroundColor = LevelHoldFilterConst.Color.darkLineColor
            bottomLineView.backgroundColor = LevelHoldFilterConst.Color.darkLineColor
            buttonLineView.backgroundColor = LevelHoldFilterConst.Color.darkLineColor
            
            updateCellTheme(for: .dark)
            
            segmentedControl.normalFontColor = LevelHoldFilterConst.Color.SegmentNormalFontColor
            segmentedControl.selectedFontColor = LevelHoldFilterConst.Color.darkSegmentSelectedFontColor
            segmentedControl.indicatorColor = LevelHoldFilterConst.Color.darkSegmentIndicatorColor
        }
    }
    
     func setFilterViewTheme(theme: FilterViewTheme) {
         self.themeType = theme
     }
    
    private func updateCellTheme(for theme: FilterViewTheme) {
        tableView.visibleCells.forEach { cell in
            if let filterCell = cell as? LevelHoldFilterTableCell {
                filterCell.updateCellStyle(for: theme, isChecked: false)
            }
        }
    }
}

extension LevelHoldFilterVC {
    
    private func setLayout() {
        view.backgroundColor = .white
        [titleLabel, topLineView, segmentedControl, bottomLineView, tableView, buttonLineView, applyButton].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(LevelHoldFilterConst.padding.titleTop)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(LevelHoldFilterConst.Size.titleHeight)
        }
        
        topLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(LevelHoldFilterConst.Size.LineHeight)
            $0.leading.trailing.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(topLineView.snp.bottom)
            $0.leading.equalToSuperview().offset(LevelHoldFilterConst.padding.defaultPadding)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(LevelHoldFilterConst.Size.segmentHeight)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(LevelHoldFilterConst.padding.bottomLineTop)
            $0.height.equalTo(LevelHoldFilterConst.Size.LineHeight)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(bottomLineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonLineView.snp.top)
        }
        
        buttonLineView.snp.makeConstraints {
            $0.bottom.equalTo(applyButton.snp.top).offset(-LevelHoldFilterConst.padding.defaultPadding)
            $0.height.equalTo(LevelHoldFilterConst.Size.LineHeight)
            $0.leading.trailing.equalToSuperview()
        }
        
        applyButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(LevelHoldFilterConst.padding.defaultPadding)
            $0.leading.trailing.equalToSuperview().inset(LevelHoldFilterConst.padding.defaultPadding)
        }
    }
    
    private func adjustModalHeight() {
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return LevelHoldFilterConst.Size.filterViewHeight
                }
            ]
            sheet.preferredCornerRadius = LevelHoldFilterConst.Size.filterViewCornerRadius
            sheet.prefersGrabberVisible = true
        }
    }
}
