//
//  CreatePostViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import UIKit

class CreatePostViewController: UIViewController {
    let createPostView = CreatePostView()
    let viewModel = CreateViewModel()
    
    override func loadView() {
        self.view = createPostView
        self.navigationItem.title = "새싹농장 글쓰기"
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(rightButtonClicked))
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftButtonClicked))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.text.bind { text in
            self.createPostView.textView.text = text
        }
        
        createPostView.textView.delegate = self
    }
    
    
    @objc func rightButtonClicked() {
        let alert = UIAlertController(title: "게시물 작성", message: "해당 내용으로 게시물을 작성하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction!) -> Void in
            self.viewModel.requestCreatePost { data in
                self.dismiss(animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func leftButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.text.value = textView.text ?? ""
    }
}
