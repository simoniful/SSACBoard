//
//  UpdateViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/05.
//

import UIKit
import RxCocoa
import RxSwift

class UpdateViewController: UIViewController {
    let updateView = UpdateView()
    let viewModel = UpdateViewModel()
    let disposeBag = DisposeBag()
    
    var postData : Post?
    var commentData: CommentElement?
    var btnActionHandler: ((Any?) -> ())?
    
    override func loadView() {
        self.view = updateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        bind()
        if let postData = postData {
            updateView.textView.text = postData.text
        }
        if let commentData = commentData {
            updateView.textView.text = commentData.comment
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }

    func setNavigation() {
        title = "수정"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: updateView.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: updateView.doneButton)
    }
    
    func bind() {
        updateView.textView.rx.text
            .orEmpty
            .bind(to: viewModel.text)
            .disposed(by: disposeBag)
        
        updateView.backButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        updateView.doneButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
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
                self.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
