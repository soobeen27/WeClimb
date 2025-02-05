//
//  PostCommentVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

class PostCommentVC: UIViewController {
    
    private let commentVM: PostCommentVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: PostCommentVM) {
        self.commentVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
