//
//  CustomSegmentedControl.swift
//  WeClimb
//
//  Created by 윤대성 on 12/30/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

/// 사용 예시:
/// ```swift
/// let segmentedControl = CustomSegmentedControl(items: ["옵션1", "옵션2", "옵션3"])
/// view.addSubview(segmentedControl)
/// segmentedControl.snp.makeConstraints {
///     $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
///     $0.leading.trailing.equalToSuperview().inset(16)
///     $0.height.equalTo(50)
/// }
///
/// segmentedControl.onSegmentChanged = { selectedIndex in
///     print("선택된 세그먼트 인덱스: \(selectedIndex)")
/// }

class CustomSegmentedControl: UIView {
    private let segmentControl: UISegmentedControl
    private let disposeBag = DisposeBag()
    
    private let indicatorView = UIView()
    private var indicatorWidthConstraint: Constraint!
    private var indicatorCenterXConstraint: Constraint!
    
    var selectedSegmentIndex: Int {
        return segmentControl.selectedSegmentIndex
    }
    
    var onSegmentChanged: ((Int) -> Void)?
    
    init(items: [String]) {
        segmentControl = UISegmentedControl(items: items)
        super.init(frame: .zero)
        setupSegmentControl()
        setupIndicatorView()
        initializeIndicatorLayout()
        bindSegmentControl()
        segmentControllerBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegmentControl() {
        addSubview(segmentControl)
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .clear
        
        segmentControl.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray
        ], for: .normal)

        segmentControl.setTitleTextAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ], for: .selected)
        
        segmentControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }
    
    private func segmentControllerBackgroundColor() {
        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setupIndicatorView() {
        addSubview(indicatorView)
        indicatorView.backgroundColor = .black
        
        let initialWidth = segmentControl.titleForSegment(at: 0)?.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width ?? 0
        
        indicatorView.snp.makeConstraints {
            $0.bottom.equalTo(segmentControl.snp.bottom).offset(2)
            $0.height.equalTo(2)
            indicatorWidthConstraint = $0.width.equalTo(initialWidth).constraint
            indicatorCenterXConstraint = $0.centerX.equalTo(segmentControl.snp.leading).offset(segmentWidth() / 2).constraint
        }
    }
    
    private func initializeIndicatorLayout() {
        let initialWidth = segmentControl.titleForSegment(at: 0)?.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width ?? 0
        let initialCenterX = segmentWidth() / 2
        
        indicatorWidthConstraint.update(offset: initialWidth)
        indicatorCenterXConstraint.update(offset: initialCenterX)
        
        layoutIfNeeded()
    }
    
    private func bindSegmentControl() {
        segmentControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] selectedIndex in
                guard let self = self,
                      let selectedTitle = self.segmentControl.titleForSegment(at: selectedIndex) else { return }
                
                let titleWidth = selectedTitle.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width
                let segmentWidth = self.segmentWidth()
                let newCenterX = segmentWidth * CGFloat(selectedIndex) + segmentWidth / 2
                
                self.indicatorWidthConstraint.update(offset: titleWidth)
                self.indicatorCenterXConstraint.update(offset: newCenterX)
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func segmentWidth() -> CGFloat {
        return segmentControl.frame.width / CGFloat(segmentControl.numberOfSegments)
    }
}

extension String {
    func size(withAttributes attributes: [NSAttributedString.Key: Any]) -> CGSize {
        return (self as NSString).size(withAttributes: attributes)
    }
}
