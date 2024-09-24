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
        label.font = UIFont.systemFont(ofSize: 15)
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
        stackView.spacing = 0
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
            facilityLabel,
            facilityInfoStackView,
            difficultyLabel,
            difficultyBarView,
            noInfoLabel
        ].forEach { addSubview($0) }
        
        hoursLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        facilityLabel.snp.makeConstraints {
            $0.top.equalTo(hoursLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        facilityInfoStackView.snp.makeConstraints {
            $0.top.equalTo(facilityLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        difficultyLabel.snp.makeConstraints {
            $0.top.equalTo(facilityInfoStackView.snp.bottom).offset(32)
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
        guard let viewModel else { return }
        
        viewModel.gymData
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [ weak self] gym in
                self?.updateView(with: gym)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateView(with gym: Gym) {
        // 운영시간 설정
        let hours = gym.additionalInfo["hours"] as? String ?? "운영시간 정보 없음"
        hoursLabel.text = hours.isEmpty ? "운영시간 정보 없음" : hours
        
        // 시설 정보 설정
        setupFacilityInfo(parking: gym.additionalInfo["parking"] as? String ?? "",
                          shower: gym.additionalInfo["shower"] as? Bool ?? false,
                          trainingBoard: gym.additionalInfo["trainingBoard"] as? Bool ?? false,
                          footWasher: gym.additionalInfo["footWasher"] as? Bool ?? false)
        
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
        // 기존에 추가된 뷰를 모두 제거
        difficultyBarView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 각 grade 문자열을 색상으로 변환하여 UIImageView 생성
        let coloredViews = grades.compactMap { grade -> UIImageView? in
            let color = grade.colorInfo.color
            
            // "rectangle.fill" 심볼을 사용하여 이미지 생성 및 색상 적용
            if let image = UIImage(systemName: "rectangle.fill")?.withTintColor(color, renderingMode: .alwaysOriginal) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .center
                imageView.clipsToBounds = true
                
                imageView.transform = CGAffineTransform(scaleX: 1.6, y: 1.5)
                return imageView
            }
            return nil
        }
        
        for imageView in coloredViews {
            difficultyBarView.addArrangedSubview(imageView)
            
            // 각 이미지뷰의 크기 설정
            imageView.snp.makeConstraints {
                $0.width.equalTo(difficultyBarView.snp.width).multipliedBy(1.0 / CGFloat(coloredViews.count))
                $0.height.equalTo(difficultyBarView.snp.height)
            }
        }
        
        // 스택뷰의 좌우 간격을 0으로 설정
        difficultyBarView.spacing = 0
    }
}
