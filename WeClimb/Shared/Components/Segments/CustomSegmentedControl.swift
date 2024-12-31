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
        
        segmentControl.selectedSegmentIndex = CustomSegmentConstants.Size.firstSegmentItem
        segmentControl.selectedSegmentTintColor = .clear
        
        segmentControl.setTitleTextAttributes([
            .font: CustomSegmentConstants.Font.normalFont,
            .foregroundColor: CustomSegmentConstants.Color.normalFontColor
        ], for: .normal)

        segmentControl.setTitleTextAttributes([
            .font: CustomSegmentConstants.Font.selectedFont,
            .foregroundColor: CustomSegmentConstants.Color.selectedFontColor
        ], for: .selected)
        
        segmentControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(CustomSegmentConstants.Size.segmentControlHeight)
        }
    }
    
    private func segmentControllerBackgroundColor() {
        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setupIndicatorView() {
        addSubview(indicatorView)
        indicatorView.backgroundColor = CustomSegmentConstants.Color.indicatorColor
        
        let initialWidth = CustomSegmentConstants.Helper.titleWidth(
            for: segmentControl.titleForSegment(at: CustomSegmentConstants.Size.firstSegmentItem),
            font: CustomSegmentConstants.Font.normalFont
        )
        
        indicatorView.snp.makeConstraints {
            $0.bottom.equalTo(segmentControl.snp.bottom).offset(CustomSegmentConstants.Spacing.indicatorBottomOffset)
            $0.height.equalTo(CustomSegmentConstants.Size.indicatorHeight)
            indicatorWidthConstraint = $0.width.equalTo(initialWidth).constraint
            indicatorCenterXConstraint = $0.centerX.equalTo(segmentControl.snp.leading)
                .offset(CustomSegmentConstants.Helper.centerX(for: segmentWidth(), at: CustomSegmentConstants.Size.firstSegmentItem))
                .constraint
        }
    }

    
    private func initializeIndicatorLayout() {
        let initialWidth = CustomSegmentConstants.Helper.titleWidth(
            for: segmentControl.titleForSegment(at: CustomSegmentConstants.Size.firstSegmentItem),
            font: CustomSegmentConstants.Font.normalFont
        )
        let initialCenterX = CustomSegmentConstants.Helper.centerX(
            for: segmentWidth(),
            at: CustomSegmentConstants.Size.firstSegmentItem
        )
        
        indicatorWidthConstraint.update(offset: initialWidth)
        indicatorCenterXConstraint.update(offset: initialCenterX)
        
        layoutIfNeeded()
    }

    
    private func bindSegmentControl() {
        segmentControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] selectedIndex in
                guard let self = self,
                      let selectedTitle = self.segmentControl.titleForSegment(at: selectedIndex) else { return }
                
                let titleWidth = CustomSegmentConstants.Helper.titleWidth(
                    for: selectedTitle,
                    font: CustomSegmentConstants.Font.normalFont
                )
                let newCenterX = CustomSegmentConstants.Helper.centerX(
                    for: self.segmentWidth(),
                    at: selectedIndex
                )
                
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
