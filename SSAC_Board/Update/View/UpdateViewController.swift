//
//  UpdateViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/05.
//

import UIKit

class UpdateViewController: UIViewController {
    let createPostView = UpdateView()
    let viewModel = UpdateViewModel()
    var postData : Post?
    var commentData: CommentElement?
    var btnActionHandler: ((Any?) -> ())?
    
    override func loadView() {
        self.view = createPostView
        self.navigationItem.title = "수정"
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(rightButtonClicked))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.text.bind { text in
            self.createPostView.textView.text = text
        }
        createPostView.textView.delegate = self
        if let postData = postData {
            createPostView.textView.text = postData.text
        }
        
        if let commentData = commentData {
            createPostView.textView.text = commentData.comment
        }
    }
    
    
    @objc func rightButtonClicked() {
        let alert = UIAlertController(title: "게시물 수정", message: "해당 내용으로 게시물을 수정하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction!) -> Void in
            if (self.postData != nil) {
                guard let postData = self.postData else { return }
                self.viewModel.requestUpdatePost(postData.id) { data in
                    guard let btnActionHandler = self.btnActionHandler else { return }
                    btnActionHandler(data!)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            if (self.commentData != nil) {
                guard let commentData = self.commentData else { return }
                self.viewModel.requestUpdateComment(commentId: commentData.id, postId: commentData.post.id) { data in
                    guard let btnActionHandler = self.btnActionHandler else { return }
                    btnActionHandler(data!)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.text.value = textView.text ?? ""
    }
}
