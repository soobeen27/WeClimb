//
//  DefaultAlertVC.swift
//  WeClimb
//
//  Created by 강유정 on 12/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public enum AlertType {
    case title
    case titleDescription
    case confirmation
}

public enum InterfaceStyle {
    case light
    case dark
}
/// 예시)
/// let alert = DefaultAlertVC(alertType: .titleDescription, interfaceStyle: .dark)
/// alert.modalPresentationStyle = .overCurrentContext
/// alert.modalTransitionStyle = .crossDissolve
/// present(alert, animated: false, completion: nil)
public class DefaultAlertVC: UIViewController{
    
    private var interfaceStyle: InterfaceStyle {
        didSet {
                setInterfaceStyle(style: interfaceStyle)
        }
    }
    
    public var cancelButtonBackgroundColor: UIColor? {
        didSet {
            cancelButton.backgroundColor = cancelButtonBackgroundColor
        }
    }
    
    public var customButtonBackgroundColor: UIColor? {
        didSet {
            customButton.backgroundColor = customButtonBackgroundColor
        }
    }
    
    public var cancelButtonTitleColor: UIColor? {
        didSet {
            cancelButton.setTitleColor(cancelButtonTitleColor, for: .normal)
        }
    }
    
    public var customButtonTitleColor: UIColor? {
        didSet {
            customButton.setTitleColor(customButtonTitleColor, for: .normal)
        }
    }
    
    public var customAction: (() -> Void)?
    
    private var alertType: AlertType
    
    private var cancelButtonTitle: String?
    private var customButtonTitle: String?
    
    private let backgroundOverlayView : UIView = {
        let view = UIView()
        view.backgroundColor = .MaterialNormal
        return view
    }()
    
    private let alertView : UIView = {
        let alertView = UIView()
        alertView.layer.cornerRadius = DefaultAlertConst.CornerRadius.alertView
        alertView.layer.masksToBounds = true
        return alertView
    }()
    
    private var cancelButton : UIButton = {
        let button = UIButton()
        button.layer.borderWidth = DefaultAlertConst.borderWidthButton
        button.layer.borderColor = UIColor.lineOpacityHeavy.cgColor
        button.layer.cornerRadius = DefaultAlertConst.CornerRadius.buttons
        button.titleLabel?.font = .customFont(style: .label2Medium)
        button.setTitleColor(.labelStrong, for: .normal)
        button.setTitle(DefaultAlertConst.Text.cancel, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private var customButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = DefaultAlertConst.CornerRadius.buttons
        button.titleLabel?.font = .customFont(style: .label2Medium)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle(DefaultAlertConst.Text.custom, for: .normal)
        return button
    }()
    
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.text = DefaultAlertConst.Text.title
        label.font = .customFont(style: .label1SemiBold)
        label.textColor = .labelStrong
        return label
    }()
    
    private var descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = DefaultAlertConst.Text.description
        label.font = .customFont(style: .body2Regular)
        label.textAlignment = .left
        label.numberOfLines = DefaultAlertConst.numberOfLinesDescription
        label.textColor = .labelNormal
        return label
    }()
    
    public init(alertType: AlertType, interfaceStyle: InterfaceStyle = .light) {
        self.alertType = alertType
        self.interfaceStyle = interfaceStyle
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setInterfaceStyle(style: interfaceStyle)
        setLayout(alertType)
        setAddTarget()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }
    
    private func setInterfaceStyle(style: InterfaceStyle) {
        switch style {
        case .light:
            alertView.backgroundColor = .white
            customButton.setTitleColor(customButtonTitleColor ?? .white, for: .normal)
            cancelButton.setTitleColor(cancelButtonTitleColor ?? .labelStrong, for: .normal)
            titleLabel.textColor = .labelStrong
            descriptionLabel.textColor = .labelNormal
            
            customButton.backgroundColor = customButtonBackgroundColor ?? .red
            cancelButton.backgroundColor = cancelButtonBackgroundColor ?? .white

        case .dark:
            alertView.backgroundColor = .fillSoildDarkNormal
            customButton.setTitleColor(customButtonTitleColor ?? .labelStrong, for: .normal)
            cancelButton.setTitleColor(cancelButtonTitleColor ?? .white, for: .normal)
            titleLabel.textColor = .white
            descriptionLabel.textColor = .labelAssistive

            customButton.backgroundColor = customButtonBackgroundColor ?? .white
            cancelButton.backgroundColor = cancelButtonBackgroundColor ?? .fillSoildDarkNormal
        }
    }
    
    @discardableResult
    public func setTitle(_ title: String, _ description: String = "") -> Self {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.minimumLineHeight = DefaultAlertConst.Size.titleHeight
        titleParagraphStyle.maximumLineHeight = DefaultAlertConst.Size.titleHeight
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .paragraphStyle: titleParagraphStyle
            ]
        )
        
        self.titleLabel.attributedText = attributedTitle
        
        let descriptionParagraphStyle = NSMutableParagraphStyle()
        descriptionParagraphStyle.minimumLineHeight = DefaultAlertConst.Size.descriptionHeight
        descriptionParagraphStyle.maximumLineHeight = DefaultAlertConst.Size.descriptionHeight
        
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
        self.customButton.setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    public func setCancelButtonTitle(_ title: String) -> Self {
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
        self.dismiss(animated: false) {
            self.customAction?()
        }
    }
}

extension DefaultAlertVC {
    
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
            $0.leading.trailing.equalToSuperview().inset(DefaultAlertConst.Spacing.alertViewHorizontalInset)
            $0.width.equalTo(DefaultAlertConst.Size.alertViewWidth)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(DefaultAlertConst.Spacing.titleTopInset)
            $0.leading.trailing.equalToSuperview().inset(DefaultAlertConst.Spacing.titleHorizontalInset)
        }
        
        if type != .title {
            alertView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(DefaultAlertConst.Spacing.descriptionHorizontalInset)
                $0.top.equalTo(titleLabel.snp.bottom).offset(DefaultAlertConst.Spacing.descriptionTopOffset)
            }
        }
        
        switch type {
        case .title:
            alertView.addSubview(cancelButton)
            
            cancelButton.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(DefaultAlertConst.Spacing.buttonTopOffset)
                $0.leading.bottom.equalToSuperview().inset(DefaultAlertConst.Spacing.buttonHorizontalInset)
                $0.width.equalTo(customButton.snp.width)
                $0.height.equalTo(customButton.snp.height)
            }
            
            customButton.snp.makeConstraints {
                $0.width.equalTo(DefaultAlertConst.Size.customButtonWidth)
                $0.height.equalTo(DefaultAlertConst.Size.customButtonHeight)
                $0.top.equalTo(cancelButton.snp.top)
                $0.trailing.bottom.equalToSuperview().inset(DefaultAlertConst.Spacing.buttonHorizontalInset)
                $0.leading.equalTo(cancelButton.snp.trailing).offset(DefaultAlertConst.Spacing.buttons)
            }
            
        case .titleDescription:
            alertView.addSubview(cancelButton)
            
            cancelButton.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(DefaultAlertConst.Spacing.buttonTopOffset)
                $0.leading.bottom.equalToSuperview().inset(DefaultAlertConst.Spacing.buttonHorizontalInset)
                $0.width.equalTo(customButton.snp.width)
                $0.height.equalTo(customButton.snp.height)
            }
            
            customButton.snp.makeConstraints {
                $0.width.equalTo(DefaultAlertConst.Size.customButtonWidth)
                $0.height.equalTo(DefaultAlertConst.Size.customButtonHeight)
                $0.top.equalTo(cancelButton.snp.top)
                $0.trailing.bottom.equalToSuperview().inset(DefaultAlertConst.Spacing.buttonHorizontalInset)
                $0.leading.equalTo(cancelButton.snp.trailing).offset(DefaultAlertConst.Spacing.buttons)
            }
        case .confirmation:
            customButton.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(DefaultAlertConst.Spacing.buttonTopOffset)
                $0.leading.trailing.bottom.equalToSuperview().inset(DefaultAlertConst.Spacing.buttonHorizontalInset)
                $0.width.equalTo(DefaultAlertConst.Size.confirmationButtonWidth)
                $0.height.equalTo(DefaultAlertConst.Size.confirmationButtonHeight)
            }
        }
    }
}

extension DefaultAlertVC {
    public func showAlert() {
        self.view.alpha = DefaultAlertConst.Animation.alphaHidden
        self.alertView.transform = CGAffineTransform(scaleX: DefaultAlertConst.Animation.zoomInScale, y: DefaultAlertConst.Animation.zoomInScale)
        
        UIView.animate(withDuration: DefaultAlertConst.Animation.fadeInDuration, animations: {
            self.view.alpha = DefaultAlertConst.Animation.alphaVisible
            self.alertView.transform = CGAffineTransform.identity
        })
    }
    
    public func dismissAlert() {
        UIView.animate(withDuration: DefaultAlertConst.Animation.fadeOutDuration, animations: {
            self.view.alpha = DefaultAlertConst.Animation.alphaHidden
            self.alertView.transform = CGAffineTransform(scaleX: DefaultAlertConst.Animation.zoomOutScale, y: DefaultAlertConst.Animation.zoomOutScale)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
            self.view.alpha = DefaultAlertConst.Animation.alphaHidden
        })
    }
}
