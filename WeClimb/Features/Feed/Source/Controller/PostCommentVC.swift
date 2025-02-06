//
//  PostCommentVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit

class PostCommentVC: UIViewController {
    
    weak var coordinator: PostCommentCoordinator?
    
    private let commentVM: PostCommentVM
    
    private let postItem: PostItem
    
    private let titleView = CommentTitleView()
    private let textFieldView = CommentTFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    init(viewModel: PostCommentVM, postItem: PostItem) {
        self.commentVM = viewModel
        self.postItem = postItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        view.backgroundColor = CommentConsts.backgroundColor
        
        [titleView, textFieldView]
            .forEach { view.addSubview($0) }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CommentConsts.titleViewHeight)
        }
        
        textFieldView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(CommentConsts.TextFieldView.Size.height)
        }
    }
}
