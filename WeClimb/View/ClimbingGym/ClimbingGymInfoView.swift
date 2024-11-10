//
//  ClimbingGymInfoView.swift
//  WeClimb
//
//  Created by 머성이 on 9/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class ClimbingGymInfoView: UIView {
    
    var viewModel: ClimbingGymVM? {
        didSet {
            bindViewModel()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // 운영 정보 레이블
    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.text = ClimbingGymNameSpace.hours
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    // 운영 정보 디테일 레이블
    private let hoursDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    // 시설 정보 레이블
    private let facilityLabel: UILabel = {
        let label = UILabel()
        label.text = ClimbingGymNameSpace.facility
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    // 시설 정보 아이콘 및 설명을 위한 스택뷰
    private lazy var facilityInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        return stackView
    }()
    
    // 주차정보 레이블
    private let parkingInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ClimbingGymNameSpace.parkingInfo
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    // 주차장 정보 설명 레이블
    private let parkingInfoDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    // 난이도 레이블
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.text = ClimbingGymNameSpace.difficulty
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    // 난이도 색상 바
    private let difficultyBarView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 3
        return stackView
    }()
    
    // 정보 없음 알림 레이블
    private let noInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ClimbingGymNameSpace.noInfo
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [
            hoursLabel,
            hoursDetailLabel,
            facilityLabel,
            facilityInfoStackView,
            parkingInfoLabel,
            parkingInfoDetailLabel,
            difficultyLabel,
            difficultyBarView,
            noInfoLabel
        ].forEach { addSubview($0) }
        
        hoursLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        hoursDetailLabel.snp.makeConstraints {
            $0.top.equalTo(hoursLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        facilityLabel.snp.makeConstraints {
            $0.top.equalTo(hoursDetailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        facilityInfoStackView.snp.makeConstraints {
            $0.top.equalTo(facilityLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        parkingInfoLabel.snp.makeConstraints {
            $0.top.equalTo(facilityInfoStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        parkingInfoDetailLabel.snp.makeConstraints {
            $0.top.equalTo(parkingInfoLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        difficultyLabel.snp.makeConstraints {
            $0.top.equalTo(parkingInfoDetailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        difficultyBarView.snp.makeConstraints {
            $0.top.equalTo(difficultyLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        noInfoLabel.snp.makeConstraints {
            $0.top.equalTo(difficultyBarView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func bindViewModel() {
        viewModel?.output.gymData
            .drive(onNext: { [weak self] gym in
                guard let gym else { return }
                self?.updateView(with: gym)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateView(with gym: Gym) {
        // 운영시간 설정
        let hours = gym.additionalInfo["hours"] as? String ?? "운영시간 정보 없음"
        hoursDetailLabel.text = hours.isEmpty ? "운영시간 정보 없음" : hours
        
        // 시설 정보 설정
        setupFacilityInfo(parking: gym.additionalInfo["parking"] as? String ?? "",
                          shower: gym.additionalInfo["shower"] as? Bool ?? false,
                          trainingBoard: gym.additionalInfo["trainingBoard"] as? Bool ?? false,
                          footWasher: gym.additionalInfo["footWasher"] as? Bool ?? false)
        
        // 주차 정보 설정
        let parking = gym.additionalInfo["parking"] as? String ?? "주차 정보 없음"
        if parking == "주차 불가" {
            parkingInfoDetailLabel.text = "주차 시설이 없습니다."
        } else if parking.isEmpty {
            parkingInfoDetailLabel.text = "주차 정보가 제공되지 않았습니다."
        } else {
            parkingInfoDetailLabel.text = "\(parking)"
        }
        
        // 난이도 색상 바 설정
        let grades = gym.grade.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        setupDifficultyBarView(from: grades)
        
        // 정보 없음 메시지 설정
        let isAnyFacilityInfoAvailable = !(gym.additionalInfo["parking"] as? String ?? "").isEmpty
        || gym.additionalInfo["shower"] as? Bool ?? false
        || gym.additionalInfo["trainingBoard"] as? Bool ?? false
        || gym.additionalInfo["footWasher"] as? Bool ?? false
        
        noInfoLabel.isHidden = isAnyFacilityInfoAvailable
    }
    
    private func setupFacilityInfo(parking: String, shower: Bool, trainingBoard: Bool, footWasher: Bool) {
        facilityInfoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 각각의 정보를 조건에 따라 표시
        if parking != "주차 불가" {
            addFacilityInfo(description: "주차", iconName: "parkingsign.circle")
        }
        if shower {
            addFacilityInfo(description: "샤워", iconName: "shower")
        }
        if trainingBoard {
            addFacilityInfo(description: "트레이닝 보드", iconName: "figure.play")
        }
        if footWasher {
            addFacilityInfo(description: "세족장", iconName: "hands.and.sparkles")
        }
    }
    
    private func addFacilityInfo(description: String, iconName: String) {
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = .label
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 24, height: 24)) }
        
        let label = UILabel()
        label.text = description
        label.font = UIFont.systemFont(ofSize: 15)
        
        let horizontalStackView = UIStackView(arrangedSubviews: [iconImageView, label])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        
        facilityInfoStackView.addArrangedSubview(horizontalStackView)
    }
    
    private func setupDifficultyBarView(from grades: [String]) {
        clearExistingViews() // 기존에 추가된 뷰를 모두 제거
        
        let coloredViews = grades.map { createGradeView(for: $0) }
        
        addViewsToStackView(coloredViews)
        
        // grade가 "B"로 시작하는 경우 containerView를 추가하지 않음
        if !grades.contains(where: { $0.hasPrefix("B") }) {
            addContainerView()
        } else {
            addDifficultyBarViewWithoutContainer()
        }
    }
    
    private func clearExistingViews() {
        difficultyBarView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func createGradeView(for grade: String) -> UIView {
        if grade.hasPrefix("B") {
            let label = UILabel()
            label.text = grade
            label.textColor = .label
            label.textAlignment = .center
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 8
            return label
        } else {
            let color = grade.colorInfo.color
            let colorView = UIView()
            colorView.backgroundColor = color
            return colorView
        }
    }
    
    private func addViewsToStackView(_ views: [UIView]) {
        for view in views {
            difficultyBarView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.width.equalTo(difficultyBarView.snp.width).multipliedBy(1.0 / CGFloat(views.count))
                $0.height.equalTo(difficultyBarView.snp.height)
            }
        }
        difficultyBarView.spacing = 0
    }
    
    private func addContainerView() {
        self.subviews.filter { $0.tag == 100 }.forEach { $0.removeFromSuperview() }
        
        let containerView = UIView()
        containerView.tag = 100
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
        
        containerView.addSubview(difficultyBarView)
        
        self.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(difficultyLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        difficultyBarView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addDifficultyBarViewWithoutContainer() {
        difficultyBarView.snp.makeConstraints {
            $0.top.equalTo(difficultyLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
    }
}
