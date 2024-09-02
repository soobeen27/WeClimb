//
//  ClimbingGymInfoView.swift
//  WeClimb
//
//  Created by 머성이 on 9/2/24.
//

import UIKit

import SnapKit

class ClimbingGymInfoView: UIView {
    
    // 시설 정보 레이블
    private let facilityLabel: UILabel = {
        let label = UILabel()
        label.text = "시설 정보"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
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
        label.text = "난이도"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    // 난이도 색상 바
    private let difficultyBarView: UIStackView = {
        let colors: [UIColor] = [.yellow, .green, .blue, .purple, .red, .orange, .brown, .black]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        for color in colors {
            let view = UIView()
            view.backgroundColor = color
            view.layer.cornerRadius = 2
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
    
    // 난이도 설명 레이블
    private let difficultyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "총 8개의 난이도가 있어요!"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    // 정보 없음 알림 레이블
    private let noInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "정보가 없거나 잘못된 정보가 있다면 알려주세요!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setupFacilityInfo() // 시설 정보 초기화
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [
            facilityLabel,
            facilityInfoStackView,
            difficultyLabel,
            difficultyBarView,
            difficultyDescriptionLabel,
            noInfoLabel
        ].forEach { addSubview($0) }
        
        facilityLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
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
        
        difficultyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(difficultyBarView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        noInfoLabel.snp.makeConstraints {
            $0.top.equalTo(difficultyDescriptionLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setupFacilityInfo() {
        let facilityItems = [
            ("지구력", "hand.raised.fill"),
            ("스트레칭존", "ruler.fill"),
            ("트레이닝존", "dumbbell.fill"),
            ("샤워실", "shower.fill")
        ]
        
        for (title, systemName) in facilityItems {
            let iconImageView = UIImageView(image: UIImage(systemName: systemName))
            iconImageView.tintColor = .black
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 24, height: 24)) }
            
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = .black
            
            let horizontalStackView = UIStackView(arrangedSubviews: [iconImageView, label])
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 8
            
            facilityInfoStackView.addArrangedSubview(horizontalStackView)
        }
    }
}
