//
//  DefaultAlertVC.swift
//  WeClimb
//
//  Created by 강유정 on 12/26/24.
//

import UIKit
import SnapKit

public enum AlertType {
    case title
    case titleDescription
    case confirmation
}

public class DefaultAlertVC: UIViewController {
    
    public var customAction: (() -> Void)?
    
    private var alertType: AlertType
    
    private var cancelButtonTitle: String?
    private var customButtonTitle: String?
    
    private let backgroundOverlayView : UIView = {
        let view = UIView()
        view.backgroundColor = .alertbackgroundGray
        return view
    }()
    
    let alertView : UIView = {
        let alertView = UIView()
        alertView.layer.cornerRadius = DefaultAlertVCNS.alertViewCornerRadius
        alertView.layer.masksToBounds = true
        alertView.backgroundColor = .white
        return alertView
    }()
    
    var cancelButton : UIButton = {
        let button = UIButton()
        button.layer.borderWidth = DefaultAlertVCNS.buttonBorderWidth
        button.layer.borderColor = UIColor.alertlightGray.cgColor
        button.layer.cornerRadius = DefaultAlertVCNS.buttonCornerRadius
        button.titleLabel?.font = .customFont(style: .label2Medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    var customButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = DefaultAlertVCNS.buttonCornerRadius
        button.titleLabel?.font = .customFont(style: .label2Medium)
        button.backgroundColor = .red
        return button
    }()
    
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .customFont(style: .label1SemiBold)
        label.textColor = .black
        return label
    }()
    
    private var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .customFont(style: .body2Regular)
        label.textAlignment = .left
        label.numberOfLines = DefaultAlertVCNS.descriptionnumberOfLines
        label.textColor = .alertTitleGray
        return label
    }()
    
    public init(alertType: AlertType) {
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setLayout(alertType)
        setAddTarget()
        
        self.view.backgroundColor = .clear
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }
    
    @discardableResult
    public func setTitle(_ title: String, _ description: String = "") -> Self {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.minimumLineHeight = DefaultAlertVCNS.titleLineHeight
        titleParagraphStyle.maximumLineHeight = DefaultAlertVCNS.titleLineHeight
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .paragraphStyle: titleParagraphStyle
            ]
        )
        
        self.titleLabel.attributedText = attributedTitle
        
        let descriptionParagraphStyle = NSMutableParagraphStyle()
        descriptionParagraphStyle.minimumLineHeight = DefaultAlertVCNS.descriptionLineHeight
        descriptionParagraphStyle.maximumLineHeight = DefaultAlertVCNS.descriptionLineHeight
        
        let attributedDescription = NSAttributedString(
            string: description,
            attributes: [
                .paragraphStyle: descriptionParagraphStyle
            ]
        )
        
        self.descriptionLabel.attributedText = attributedDescription
        
        return self
    }
    
    @discardableResult
    public func setCustomButtonTitle(_ title: String) -> Self {
        self.customButtonTitle = title
        self.customButton.setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    public func setCancelButtonTitle(_ title: String) -> Self {
        self.cancelButtonTitle = title
        self.cancelButton.setTitle(title, for: .normal)
        return self
    }
    
    private func setAddTarget() {
        cancelButton.addTarget(self, action: #selector(dismissCurrentVC), for: .touchUpInside)
        customButton.addTarget(self, action: #selector(tappedCustomButton), for: .touchUpInside)
    }
    
    @objc
    private func dismissCurrentVC() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func tappedCustomButton() {
        self.dismiss(animated: true) {
            self.customAction?()
        }
    }
}

extension DefaultAlertVC {
    
    private func setTitle() {
        if let cancelTitle = cancelButtonTitle {
            self.cancelButton.setTitle(cancelTitle, for: .normal)
        } else {
            let cancelTitle = (self.alertType == .titleDescription) ? "취소" : "확인"
            self.cancelButton.setTitle(cancelTitle, for: .normal)
        }
        
        if let customTitle = customButtonTitle {
            self.customButton.setTitle(customTitle, for: .normal)
        } else {
            self.customButton.setTitle("확인", for: .normal)
        }
    }
    
    private func setLayout(_ type: AlertType) {
        [backgroundOverlayView, alertView]
            .forEach { self.view.addSubview($0) }
        
        [titleLabel, customButton]
            .forEach { alertView.addSubview($0) }
        
        backgroundOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(DefaultAlertVCNS.alertViewHorizontalInset)
            $0.width.equalTo(DefaultAlertVCNS.alertViewWidth)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(DefaultAlertVCNS.titleTopInset)
            $0.leading.trailing.equalToSuperview().inset(DefaultAlertVCNS.titleHorizontalInset)
        }
        
        if type != .title {
            alertView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(DefaultAlertVCNS.descriptionHorizontalInset)
                $0.top.equalTo(titleLabel.snp.bottom).offset(DefaultAlertVCNS.descriptionTopOffset)
            }
        }
        
        switch type {
        case .title:
            alertView.addSubview(cancelButton)
            
            cancelButton.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(DefaultAlertVCNS.buttonTopOffset)
                $0.leading.bottom.equalToSuperview().inset(DefaultAlertVCNS.buttonHorizontalInset)
                $0.width.equalTo(customButton.snp.width)
                $0.height.equalTo(customButton.snp.height)
            }
            
            customButton.snp.makeConstraints {
                $0.width.equalTo(DefaultAlertVCNS.customButtonWidth)
                $0.height.equalTo(DefaultAlertVCNS.customButtonHeight)
                $0.top.equalTo(cancelButton.snp.top)
                $0.trailing.bottom.equalToSuperview().inset(DefaultAlertVCNS.buttonHorizontalInset)
                $0.leading.equalTo(cancelButton.snp.trailing).offset(DefaultAlertVCNS.buttonSpacing)
            }
            
        case .titleDescription:
            alertView.addSubview(cancelButton)
            
            cancelButton.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(DefaultAlertVCNS.buttonTopOffset)
                $0.leading.bottom.equalToSuperview().inset(DefaultAlertVCNS.buttonHorizontalInset)
                $0.width.equalTo(customButton.snp.width)
                $0.height.equalTo(customButton.snp.height)
            }
            
            customButton.snp.makeConstraints {
                $0.width.equalTo(DefaultAlertVCNS.customButtonWidth)
                $0.height.equalTo(DefaultAlertVCNS.customButtonHeight)
                $0.top.equalTo(cancelButton.snp.top)
                $0.trailing.bottom.equalToSuperview().inset(DefaultAlertVCNS.buttonHorizontalInset)
                $0.leading.equalTo(cancelButton.snp.trailing).offset(DefaultAlertVCNS.buttonSpacing)
            }
        case .confirmation:
            customButton.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(DefaultAlertVCNS.buttonTopOffset)
                $0.leading.trailing.bottom.equalToSuperview().inset(DefaultAlertVCNS.buttonHorizontalInset)
                $0.width.equalTo(DefaultAlertVCNS.confirmationButtonWidth)
                $0.height.equalTo(DefaultAlertVCNS.confirmationButtonHeight)
            }
        }
    }
}


extension DefaultAlertVC {
    public func showAlert() {
        self.view.alpha = DefaultAlertVCNS.alphaHidden
        self.alertView.transform = CGAffineTransform(scaleX: DefaultAlertVCNS.zoomInScale, y: DefaultAlertVCNS.zoomInScale)
        
        UIView.animate(withDuration: DefaultAlertVCNS.fadeInDuration, animations: {
            self.view.alpha = DefaultAlertVCNS.alphaVisible
            self.alertView.transform = CGAffineTransform.identity
        })
    }
    
    public func dismissAlert() {
        UIView.animate(withDuration: DefaultAlertVCNS.fadeOutDuration, animations: {
            self.view.alpha = DefaultAlertVCNS.alphaHidden
            self.alertView.transform = CGAffineTransform(scaleX: DefaultAlertVCNS.zoomOutScale, y: DefaultAlertVCNS.zoomOutScale)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}
