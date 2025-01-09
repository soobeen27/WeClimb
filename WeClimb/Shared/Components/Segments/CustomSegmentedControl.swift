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
    
    var normalFontColor: UIColor = CustomSegmentConst.Color.normalFontColor {
        didSet {
            updateSegmentTextColors()
        }
    }
    
    var selectedFontColor: UIColor = CustomSegmentConst.Color.selectedFontColor {
        didSet {
            updateSegmentTextColors()
        }
    }
    
    var indicatorColor: UIColor = CustomSegmentConst.Color.indicatorColor {
        didSet {
            indicatorView.backgroundColor = indicatorColor
        }
    }
    
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
        
        segmentControl.selectedSegmentIndex = CustomSegmentConst.Size.firstSegmentItem
        segmentControl.selectedSegmentTintColor = .clear
        
        segmentControl.setTitleTextAttributes([
            .font: CustomSegmentConst.Font.normalFont,
            .foregroundColor: CustomSegmentConst.Color.normalFontColor
        ], for: .normal)

        segmentControl.setTitleTextAttributes([
            .font: CustomSegmentConst.Font.selectedFont,
            .foregroundColor: CustomSegmentConst.Color.selectedFontColor
        ], for: .selected)
        
        segmentControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(CustomSegmentConst.Size.segmentControlHeight)
        }
        
        updateSegmentTextColors()
    }
    
    private func updateSegmentTextColors() {
        segmentControl.setTitleTextAttributes([
            .font: CustomSegmentConst.Font.normalFont,
            .foregroundColor: normalFontColor
        ], for: .normal)

        segmentControl.setTitleTextAttributes([
            .font: CustomSegmentConst.Font.selectedFont,
            .foregroundColor: selectedFontColor
        ], for: .selected)
    }
    
    private func segmentControllerBackgroundColor() {
        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setupIndicatorView() {
        addSubview(indicatorView)
//        indicatorView.backgroundColor = CustomSegmentConst.Color.indicatorColor
        indicatorView.backgroundColor = indicatorColor
        
        let initialWidth = CustomSegmentConst.Helper.titleWidth(
            for: segmentControl.titleForSegment(at: CustomSegmentConst.Size.firstSegmentItem),
            font: CustomSegmentConst.Font.normalFont
        )
        
        indicatorView.snp.makeConstraints {
            $0.bottom.equalTo(segmentControl.snp.bottom).offset(CustomSegmentConst.Spacing.indicatorBottomOffset)
            $0.height.equalTo(CustomSegmentConst.Size.indicatorHeight)
            indicatorWidthConstraint = $0.width.equalTo(initialWidth).constraint
            indicatorCenterXConstraint = $0.centerX.equalTo(segmentControl.snp.leading)
                .offset(CustomSegmentConst.Helper.centerX(for: segmentWidth(), at: CustomSegmentConst.Size.firstSegmentItem))
                .constraint
        }
    }

    
    private func initializeIndicatorLayout() {
        let initialWidth = CustomSegmentConst.Helper.titleWidth(
            for: segmentControl.titleForSegment(at: CustomSegmentConst.Size.firstSegmentItem),
            font: CustomSegmentConst.Font.normalFont
        )
        let initialCenterX = CustomSegmentConst.Helper.centerX(
            for: segmentWidth(),
            at: CustomSegmentConst.Size.firstSegmentItem
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
                
                self.onSegmentChanged?(selectedIndex)
                
                let titleWidth = CustomSegmentConst.Helper.titleWidth(
                    for: selectedTitle,
                    font: CustomSegmentConst.Font.normalFont
                )
                let newCenterX = CustomSegmentConst.Helper.centerX(
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
