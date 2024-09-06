//
//  RangePickerVC.swift
//  WeClimb
//
//  Created by 머성이 on 9/6/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class RangePickerVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let pickerView = UIPickerView()
    
    private let ranges = ["120 ~ 130", "130 ~ 140", "140 ~ 150", "150 ~ 160", "160 ~ 170", "170 ~ 180", "180 ~ 190", "190 ~ 200"]
    
    var selectedRange = PublishRelay<String>()

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        [
            pickerView,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        pickerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        confirmButton.rx.tap
            .subscribe(onNext: {
                let selectedRow = self.pickerView.selectedRow(inComponent: 0)
                let selectedRangeText = self.ranges[selectedRow]
                self.selectedRange.accept(selectedRangeText)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension RangePickerVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ranges.count
    }
}

extension RangePickerVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ranges[row]
    }
}
