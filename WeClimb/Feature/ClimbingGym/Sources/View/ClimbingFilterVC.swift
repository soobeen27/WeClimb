//
//  ClimbingFilterVC.swift
//  WeClimb
//
//  Created by 머성이 on 11/11/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ClimbingFilterVC: UIViewController, UIScrollViewDelegate {
    
    private var selectedHoldColor: String?
    
    private let viewModel: ClimbingFilterVM
    private let disposeBag = DisposeBag()
    
    private let selectedTabSubject = BehaviorSubject<SelectedTab>(value: .hold)
    
    let filterConditionsRelay = BehaviorRelay<FilterConditions>(value: FilterConditions(
        holdColor: nil,
        heightRange: (0, 200),
        armReachRange: (0, 200)
    ))
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    init(gymName: String, grade: String, initialFilterConditions: FilterConditions) {
        self.viewModel = ClimbingFilterVM(gymName: gymName, grade: grade)
        super.init(nibName: nil, bundle: nil)
        
        // 초기 필터 조건 설정
        self.selectedHoldColor = initialFilterConditions.holdColor
        self.filterConditionsRelay.accept(initialFilterConditions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let closeImage = UIImage(systemName: "xmark")
        button.setImage(closeImage, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "필터"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let menuHoldLabel: UILabel = {
        let label = UILabel()
        label.text = "홀드"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let menuArmReachLabel: UILabel = {
        let label = UILabel()
        label.text = "키,암리치"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let holdLabel: UILabel = {
        let label = UILabel()
        label.text = "홀드"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let armReachLabel: UILabel = {
        let label = UILabel()
        label.text = "팔 길이"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let heightWaveLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let armReachWaveLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = UIColor.mainPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let heightSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.minimumValue = 0
        slider.maximumValue = 200
        slider.lowerValue = 0
        slider.upperValue = 200
        slider.backgroundColor = .clear
        return slider
    }()
    
    private lazy var heightMinTextField: UITextField = {
        let textField = createTextFieldWithCM()
        textField.text = "0"
        return textField
    }()
    
    private lazy var heightMaxTextField: UITextField = {
        let textField = createTextFieldWithCM()
        textField.text = "200"
        return textField
    }()
    
    private let armReachSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.minimumValue = 0
        slider.maximumValue = 200
        slider.lowerValue = 0
        slider.upperValue = 200
        slider.backgroundColor = .clear
        return slider
    }()
    
    private lazy var armReachMinTextField: UITextField = {
        let textField = createTextFieldWithCM()
        textField.text = "0"
        return textField
    }()
    
    private lazy var armReachMaxTextField: UITextField = {
        let textField = createTextFieldWithCM()
        textField.text = "200"
        return textField
    }()
    
    private func createTextFieldWithCM() -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.textColor = .label
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.systemGray5
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.keyboardType = .numberPad
        
        let cmLabel = UILabel()
        cmLabel.text = "cm  "
        cmLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cmLabel.textColor = .label
        cmLabel.sizeToFit()
        textField.rightView = cmLabel
        textField.rightViewMode = .always
        return textField
    }
    
    private let viewOptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private let indicatorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let indicatorBar2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let indicatorBar3: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var holdCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 80, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SelectSettingCell.self, forCellWithReuseIdentifier: SelectSettingCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bindViewModel()
        setupBindings()
        setupInitialSliderValues()
        setupTabActions()
        bindTabSelection()
        setupCloseButtonAction()
        setupConfirmButtonAction()
        scrollView.delegate = self
    }
    
    private func setupBindings() {
        bindHeightSlider()
        bindArmReachSlider()
        bindHeightTextFields()
        bindArmReachTextFields()
    }
    
    // MARK: - Layout
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [
            closeButton,
            titleLabel,
            scrollView,
            viewOptionStackView,
            indicatorBar,
        ].forEach { view.addSubview($0) }
        
        [
            contentView
        ].forEach { scrollView.addSubview($0) }
        
        [
            menuHoldLabel,
            menuArmReachLabel
        ].forEach { viewOptionStackView.addArrangedSubview($0) }
        
        [
            holdLabel,
            holdCollectionView,
            indicatorBar2,
            heightLabel,
            heightSlider,
            heightMinTextField,
            heightWaveLabel,
            heightMaxTextField,
            indicatorBar3,
            armReachLabel,
            armReachSlider,
            armReachMinTextField,
            armReachWaveLabel,
            armReachMaxTextField,
            confirmButton
        ].forEach { contentView.addSubview($0) }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(indicatorBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView.snp.height)
        }
        
        viewOptionStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        indicatorBar.snp.makeConstraints {
            $0.top.equalTo(viewOptionStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        holdLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        holdCollectionView.snp.makeConstraints {
            $0.top.equalTo(holdLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        indicatorBar2.snp.makeConstraints {
            $0.top.equalTo(holdCollectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(indicatorBar2.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightSlider.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        heightMinTextField.snp.makeConstraints {
            $0.top.equalTo(heightSlider.snp.bottom).offset(8)
            $0.leading.equalTo(heightSlider.snp.leading)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().dividedBy(3).offset(-16)
        }
        
        heightWaveLabel.snp.makeConstraints {
            $0.centerY.equalTo(heightMinTextField)
            $0.leading.equalTo(heightMinTextField.snp.trailing)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().dividedBy(6)
        }
        
        heightMaxTextField.snp.makeConstraints {
            $0.centerY.equalTo(heightMinTextField)
            $0.leading.equalTo(heightWaveLabel.snp.trailing)
            $0.trailing.equalTo(heightSlider.snp.trailing)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().dividedBy(3).offset(-16)
        }
        
        indicatorBar3.snp.makeConstraints {
            $0.top.equalTo(heightMaxTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        armReachLabel.snp.makeConstraints {
            $0.top.equalTo(indicatorBar3.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        armReachSlider.snp.makeConstraints {
            $0.top.equalTo(armReachLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        armReachMinTextField.snp.makeConstraints {
            $0.top.equalTo(armReachSlider.snp.bottom).offset(8)
            $0.leading.equalTo(armReachSlider.snp.leading)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().dividedBy(3).offset(-16)
        }
        
        armReachWaveLabel.snp.makeConstraints {
            $0.centerY.equalTo(armReachMinTextField)
            $0.leading.equalTo(armReachMinTextField.snp.trailing)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().dividedBy(6)
        }
        
        armReachMaxTextField.snp.makeConstraints {
            $0.centerY.equalTo(armReachMinTextField)
            $0.leading.equalTo(armReachWaveLabel.snp.trailing)
            $0.trailing.equalTo(armReachSlider.snp.trailing)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().dividedBy(3).offset(-16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(armReachMaxTextField.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalTo(contentView)
        }
    }
    
    private func setupInitialSliderValues() {
        let currentConditions = filterConditionsRelay.value
        
        if let heightRange = currentConditions.heightRange {
            heightSlider.lowerValue = Double(heightRange.0)
            heightSlider.upperValue = Double(heightRange.1)
            
            heightMinTextField.text = "\(heightRange.0)"
            heightMaxTextField.text = "\(heightRange.1)"
        }
        
        if let armReachRange = currentConditions.armReachRange {
            armReachSlider.lowerValue = Double(armReachRange.0)
            armReachSlider.upperValue = Double(armReachRange.1)
            
            armReachMinTextField.text = "\(armReachRange.0)"
            armReachMaxTextField.text = "\(armReachRange.1)"
        }
    }
    
    // MARK: - Actions Setup
    private func setupTabActions() {
        let holdTapGesture = UITapGestureRecognizer()
        let armReachTapGesture = UITapGestureRecognizer()
        
        menuHoldLabel.addGestureRecognizer(holdTapGesture)
        menuArmReachLabel.addGestureRecognizer(armReachTapGesture)
        
        holdTapGesture.rx.event
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.scrollToSection(.hold)
            }
            .disposed(by: disposeBag)
        
        armReachTapGesture.rx.event
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.scrollToSection(.armReach)
            }
            .disposed(by: disposeBag)
    }
    
    private func scrollToSection(_ section: SelectedTab) {
        let totalHeight = scrollView.contentSize.height - scrollView.bounds.height
        let offsetY: CGFloat
        
        switch section {
        case .hold:
            offsetY = 0
        case .armReach:
            let threshold: CGFloat = 1.2
            offsetY = totalHeight * threshold
        }
        
        scrollView.setContentOffset(CGPoint(x: 0, y: max(offsetY, 0)), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let totalHeight = scrollView.contentSize.height - scrollView.bounds.height
        let scrollProgress = totalHeight > 0 ? currentOffsetY / totalHeight : 0
        
        let threshold: CGFloat = 1.2
        
        if scrollProgress >= threshold {
            selectedTabSubject.onNext(.armReach)
        } else {
            selectedTabSubject.onNext(.hold)
        }
    }
    
    
    private func bindTabSelection() {
        selectedTabSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] selectedTab in
                self?.updateTabSelection(selectedTab)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCloseButtonAction() {
        closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateTabSelection(_ selectedTab: SelectedTab) {
        switch selectedTab {
        case .hold:
            menuHoldLabel.textColor = .label
            menuArmReachLabel.textColor = .gray
        case .armReach:
            menuHoldLabel.textColor = .gray
            menuArmReachLabel.textColor = .label
        }
    }
    
    // MARK: - 슬라이더 관련 로직
    // 키 관련
    private func bindHeightSlider() {
        heightSlider.lowerValueChanged = { [weak self] value in
            guard let self = self else { return }
            let lowerValue = Int(value)
            self.heightMinTextField.text = "\(lowerValue)"
        }
        
        heightSlider.upperValueChanged = { [weak self] value in
            guard let self = self else { return }
            let upperValue = Int(value)
            self.heightMaxTextField.text = "\(upperValue)"
        }
    }
    
    private func bindHeightTextFields() {
        heightMinTextField.rx.text.orEmpty
            .compactMap { Int($0) }
            .map { max(0, min($0, 200)) }
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.heightMinTextField.text = "\(value)"
                self.heightSlider.lowerValue = Double(value)
            })
            .disposed(by: disposeBag)
        
        heightMaxTextField.rx.text.orEmpty
            .compactMap { Int($0) }
            .map { max(0, min($0, 200)) }
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.heightMaxTextField.text = "\(value)"
                self.heightSlider.upperValue = Double(value)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindArmReachSlider() {
        armReachSlider.lowerValueChanged = { [weak self] value in
            guard let self = self else { return }
            let lowerValue = Int(value)
            self.armReachMinTextField.text = "\(lowerValue)"
        }
        
        armReachSlider.upperValueChanged = { [weak self] value in
            guard let self = self else { return }
            let upperValue = Int(value)
            self.armReachMaxTextField.text = "\(upperValue)"
        }
    }
    
    private func bindArmReachTextFields() {
        armReachMinTextField.rx.text.orEmpty
            .compactMap { Int($0) }
            .map { max(0, min($0, 200)) }
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.armReachMinTextField.text = "\(value)"
                self.armReachSlider.lowerValue = Double(value)
            })
            .disposed(by: disposeBag)
        
        armReachMaxTextField.rx.text.orEmpty
            .compactMap { Int($0) }
            .map { max(0, min($0, 200)) }
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.armReachMaxTextField.text = "\(value)"
                self.armReachSlider.upperValue = Double(value)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        heightSlider.lowerValueChanged = { [weak self] lowerValue in
            guard let self = self else { return }
            let lower = Int(lowerValue)
            let upper = Int(self.heightSlider.upperValue)
            self.viewModel.updateFilterCondition(heightRange: (lower, upper))
        }
        
        heightSlider.upperValueChanged = { [weak self] upperValue in
            guard let self = self else { return }
            let lower = Int(self.heightSlider.lowerValue)
            let upper = Int(upperValue)
            self.viewModel.updateFilterCondition(heightRange: (lower, upper))
        }
        
        armReachSlider.lowerValueChanged = { [weak self] lowerValue in
            guard let self = self else { return }
            let lower = Int(lowerValue)
            let upper = Int(self.armReachSlider.upperValue)
            self.viewModel.updateFilterCondition(armReachRange: (lower, upper))
        }
        
        armReachSlider.upperValueChanged = { [weak self] upperValue in
            guard let self = self else { return }
            let lower = Int(self.armReachSlider.lowerValue)
            let upper = Int(upperValue)
            self.viewModel.updateFilterCondition(armReachRange: (lower, upper))
        }
    }
    
    // MARK: - Confirm Button Action
    private func setupConfirmButtonAction() {
        confirmButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                let filterConditions = FilterConditions(
                    holdColor: self.selectedHoldColor,
                    heightRange: (Int(self.heightSlider.lowerValue), Int(self.heightSlider.upperValue)),
                    armReachRange: (Int(self.armReachSlider.lowerValue), Int(self.armReachSlider.upperValue))
                )
                
                self.filterConditionsRelay.accept(filterConditions)
                
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}

extension ClimbingFilterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Hold.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectSettingCell.className,
            for: indexPath
        ) as? SelectSettingCell else {
            return UICollectionViewCell()
        }
        
        let hold = Hold.allCases[indexPath.row]
        cell.configure(item: hold)
        
        if hold.string == selectedHoldColor {
            cell.layer.borderColor = UIColor.label.cgColor
            cell.layer.borderWidth = 2.0
        } else {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0.0
        }
        return cell
    }
}

extension ClimbingFilterVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = Hold.allCases[indexPath.row]
        
        if selectedHoldColor == selected.string {
            selectedHoldColor = nil
        } else {
            selectedHoldColor = selected.string
        }
        
        collectionView.reloadData()
        
        let updatedConditions = FilterConditions(
            holdColor: selectedHoldColor,
            heightRange: filterConditionsRelay.value.heightRange,
            armReachRange: filterConditionsRelay.value.armReachRange
        )
        
        filterConditionsRelay.accept(updatedConditions)
        
        print("현재 필터 조건: \(updatedConditions)")
    }
}

enum SelectedTab {
    case hold
    case armReach
}
