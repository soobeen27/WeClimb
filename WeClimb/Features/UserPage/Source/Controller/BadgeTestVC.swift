//
//  BadgeTestVC.swift
//  WeClimb
//
//  Created by 윤대성 on 1/31/25.
//

import UIKit

import SnapKit
import SwiftUI

class BadgeTestVC: UIViewController {
    
    private let testBadge: UserFeedBadgeView = {
       let test = UserFeedBadgeView()
        return test
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        [
            testBadge,
        ].forEach { view.addSubview($0) }
        
        testBadge.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

//extension UIViewController {
//    private struct Preview: UIViewControllerRepresentable {
//            let viewController: UIViewController
//
//            func makeUIViewController(context: Context) -> UIViewController {
//                return viewController
//            }
//
//            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//            }
//        }
//
//        func toPreview() -> some View {
//            Preview(viewController: self)
//        }
//}
//
//struct MyViewController_PreViews: PreviewProvider {
//    static var previews: some View {
//        BadgeTestVC().toPreview()
//    }
//}
